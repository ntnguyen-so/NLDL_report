import pickle

import os
import re
import numpy as np
import pandas as pd
from torch.utils.data import DataLoader, Dataset

class Ocean_Dataset(Dataset):
    def __init__(self, data_input, eval_length=48, use_index_list=None, missing_ratio=0.0):
        self.eval_length = eval_length

        self.observed_values, self.observed_masks, self.gt_masks = self.prepare_data(data_input, missing_ratio)
        print(self.observed_values.shape)
        print(self.observed_masks.shape)
        print(self.gt_masks.shape)

        # calc mean and std and normalize values
        # (it is the same normalization as Cao et al. (2018) (https://github.com/caow13/BRITS))
        num_col = 1
        tmp_values = self.observed_values.reshape(-1, num_col)
        tmp_masks = self.observed_masks.reshape(-1, num_col)
        mean = np.zeros(num_col)
        std = np.zeros(num_col)
        for k in range(num_col):
            c_data = tmp_values[:, k][tmp_masks[:, k] == 1]
            mean[k] = c_data.mean()
            std[k] = c_data.std()
        self.observed_values = (
            (self.observed_values - mean) / std * self.observed_masks
        )
        
        self.observed_values = self.observed_values
        self.observed_masks = self.observed_masks
        self.gt_masks = self.gt_masks
        
        self.observed_values = self.observed_values.reshape(-1, eval_length, 1)
        self.observed_masks = self.observed_masks.reshape(-1, eval_length, 1)
        self.gt_masks = self.gt_masks.reshape(-1, eval_length, 1)
        
        print(self.observed_values.shape)
        print(self.observed_masks.shape)
        print(self.gt_masks.shape)

        if use_index_list is None:
            self.use_index_list = np.arange(len(self.observed_values))
        else:
            self.use_index_list = use_index_list
            
    def prepare_data(self, data_input, missing_ratio=0.1):
        observed_values = np.copy(data_input) 
        observed_values = observed_values.reshape(-1, 1)
        observed_masks = ~np.isnan(observed_values)

        # randomly set some percentage as ground-truth
        masks = observed_masks.reshape(-1,1).copy()
        obs_indices = np.where(masks)[0].tolist()
        miss_indices = np.random.choice(
            obs_indices, (int)(len(obs_indices) * missing_ratio), replace=False
        )
        masks[miss_indices] = False
        gt_masks = masks.reshape(observed_masks.shape)

        observed_values = np.nan_to_num(observed_values)
        observed_masks = observed_masks.astype("float32")
        gt_masks = gt_masks.astype("float32")

        return observed_values, observed_masks, gt_masks

    def __getitem__(self, org_index):
        index = self.use_index_list[org_index]
        s = {
            "observed_data": self.observed_values[index],
            "observed_mask": self.observed_masks[index],
            "gt_mask": self.gt_masks[index],
            "timepoints": np.arange(self.eval_length),
        }
        return s

    def __len__(self):
        return len(self.use_index_list)


def get_dataloader(data_input, nfold=None, batch_size=16, missing_ratio=0.1,eval_length=48):

    # only to obtain total length of dataset
    dataset = Ocean_Dataset(data_input, missing_ratio=missing_ratio, eval_length=eval_length)
    indlist = np.arange(len(dataset))

    # np.random.seed(seed)
    # np.random.shuffle(indlist)

    # 5-fold test
    # start = (int)(nfold * 0.2 * len(dataset))
    # end = (int)((nfold + 1) * 0.2 * len(dataset))
    # test_index = indlist[start:end]
    # remain_index = np.delete(indlist, np.arange(start, end))

    # np.random.seed(seed)
    # np.random.shuffle(remain_index)
    # num_train = (int)(len(dataset) * 1)
    train_index = indlist[:]

    dataset = Ocean_Dataset(
        data_input, use_index_list=train_index, missing_ratio=missing_ratio, eval_length=eval_length
    )
    train_loader = DataLoader(dataset, batch_size=batch_size, shuffle=1)
    
    # test_dataset = Ocean_Dataset(
        # data_input, use_index_list=test_index, missing_ratio=missing_ratio, eval_length=eval_length
    # )
    # test_loader = DataLoader(test_dataset, batch_size=batch_size, shuffle=0)
    return train_loader
