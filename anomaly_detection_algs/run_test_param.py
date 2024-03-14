import multiprocessing
import subprocess
import time
import random
from datetime import datetime
import traceback
import os

def update_data(commands, data_name):
    for i in range(len(commands)):
        commands[i] = commands[i].replace("<<data_name>>", data_name)
        
    return commands
    
def is_done(command):
    formatted_command = command.replace("<<data_name>>", data_name)
    
    start_str_output = formatted_command.find("/results/")
    end_str_output = formatted_command.find(".ts")
    
    if start_str_output >= 0 and end_str_output >= 0:
        output_file = formatted_command[start_str_output:end_str_output] + ".ts"
        output_file = output_file.replace("/results", "./2-results")
        
        if os.path.isfile(output_file):
            return True
            
    start_str_output = formatted_command.find("/results/")
    end_str_output = formatted_command.find(".pkl")
    
    if start_str_output >= 0 and end_str_output >= 0:
        output_file = formatted_command[start_str_output:end_str_output] + ".ts"
        output_file = output_file.replace("/results", "./2-results")
        
        if os.path.isfile(output_file):
            return True
    
    return False
    
    
    
def logging(message):
    f = open(logfile, "a")
    f.write(f"{datetime.now()}," + message)
    f.close()

def execute(command):
    logging(f"Executing: {command}")
    if is_done(command):
        return
        
    process = subprocess.Popen(command, shell=True)
    try:
        process.wait(timeout=timeout)  # Set the timeout directly in the subprocess
        logging(f"Completed: {command}")
    except subprocess.TimeoutExpired:
        process.terminate()  # Terminate the process if timeout is reached
        logging(f"Timeout: {command}")
    except:
        logging(f"Error: {command}")

if __name__ == '__main__':
    num_cores = 32# multiprocessing.cpu_count()  # Specify the number of cores you have
    timeout =7200*2  # Set the timeout duration (in seconds)
    learning_method = "4-param_optimization/experiments.txt"
    
    with open(learning_method, "r") as f:
        commands = f.readlines()
    
    data_name = "Tide_pressure"
    logfile = data_name + ".log"
    
    commands=update_data(commands, data_name)

    # Start the programs in parallel using a process pool
    with multiprocessing.Pool(processes=num_cores) as pool:
        pool.map(execute, commands)

    print("All commands completed.")
