#!/usr/bin/python
import numpy as np
import time

# from meanimpute import meanimpute_recovery

import argparse
import torch
import datetime
import json
import yaml
import os

from main_model import CSDI_Physio
from dataset_ocean import get_dataloader
from utils import train, evaluate

parser = argparse.ArgumentParser()
parser.add_argument("--config", type=str, default="base.yaml")
parser.add_argument('--device', default='cuda:0', help='Device for Attack')
parser.add_argument("--seed", type=int, default=1)
parser.add_argument("--unconditional", action="store_true")
parser.add_argument("--modelfolder", type=str, default="")
parser.add_argument("--testmissingratio", type=float, default=0.1)
parser.add_argument(
    "--nfold", type=int, default=0, help="for 5fold test (valid value:[0-4])"
)
parser.add_argument("--nsample", type=int, default=100)
parser.add_argument("--dataset_name", type=str, default='Tide_pressure')
args = parser.parse_args()
args.device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')




def recover_matrix(matrix):
    return meanimpute_recovery(matrix);

# end function


def rmv_main(algcode, filename_input, filename_output, runtime):
    print('inside CSDI')
    # configure alg
    path = "config/" + args.config
    with open(path, "r") as f:
        config = yaml.safe_load(f)

    config["model"]["is_unconditional"] = args.unconditional
    config["model"]["test_missing_ratio"] = args.testmissingratio

    print(json.dumps(config, indent=4))
    
    # save model checkpoints
    current_time = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
    foldername = "./save/ocean_fold" + str(args.nfold) + "_" + current_time + "/"
    print('model folder:', foldername)
    os.makedirs(foldername, exist_ok=True)
    with open(foldername + "config.json", "w") as f:
        json.dump(config, f, indent=4)
        

    matrix = np.loadtxt(filename_input)
    n = len(matrix)
    print(matrix.shape)
    
    train_loader = get_dataloader(
        data_input=matrix,
        nfold=args.nfold,
        batch_size=config["train"]["batch_size"],
        missing_ratio=config["model"]["test_missing_ratio"],
        eval_length=1
    )

    model = CSDI_Physio(config, args.device, target_dim=1).to(args.device)
    
    start_time = time.time();
    
    train(
        model,
        config["train"],
        train_loader,
        foldername=foldername,
        )
        
    res = evaluate(model, train_loader, nsample=matrix.shape[0]*matrix.shape[1], scaler=1, foldername=foldername)
    res = np.array(res)
    res = res.reshape((-1, 1))
    print(res.shape)
    
    
    end_time = time.time()
    
    if runtime > 0:
        np.savetxt(filename_output, np.array([(end_time - start_time) * 1000 * 1000]))
    else:
        j = 0
        for i in range(matrix.shape[1]):
            matrix[:, i] = res[j:j+matrix.shape[0], 0]
            j += matrix.shape[0]
            
        #end for
        np.savetxt(filename_output, matrix)
        
    print()
    print('Time (CSDI):', ((end_time - start_time) * 1000 * 1000))

# end function
