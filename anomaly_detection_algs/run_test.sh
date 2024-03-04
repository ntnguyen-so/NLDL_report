#!/bin/bash
 
data_file=Tide_Pressure
execution_log=2-results/00_Tide_Pressure_log.txt
 
# Function to run a program and track the total number of running processes
run_program() {
  echo "Running alg.: $1"
  cd 2-results
  if [ -f $1_$data_file.ts ]; then
    echo $1 "done, exit"
    cd ..
    ((running_processes--))
  else   
      cd ..
      echo $1 "not executed yet"
	  
	  if [[ " ${unsupervised[*]} " =~ " $1 " ]]; then
	    echo "unsupervised"
	    start=`date +%s.%N`
		timeout 2h docker run --rm --cpus=1 -v $(pwd)/1-data:/data:ro -v $(pwd)/2-results:/results:rw $1:latest execute-algorithm '{"executionType": "execute", "dataInput": "/data/'$data_file'.total.csv", "dataOutput": "/results/'$1'_'$data_file'.ts"}' &
		end=`date +%s.%N`
		wait
	  else	  
	    echo "semi-supervised"
	    timeout 2h docker run --rm --cpus=1 -v $(pwd)/1-data:/data:ro -v $(pwd)/2-results:/results:rw $1:latest execute-algorithm '{"executionType": "train", "dataInput": "/data/'$data_file'.train.csv", "dataOutput": "/results/'$1'_'$data_file'.ts", "modelOutput": "/results/'$1'_'$data_file'.pkl"}' &
	    wait
	    start=`date +%s.%N`
	    timeout 2h docker run --rm --cpus=1 -v $(pwd)/1-data:/data:ro -v $(pwd)/2-results:/results:rw $1:latest execute-algorithm '{"executionType": "execute", "dataInput": "/data/'$data_file'.test.csv", "dataOutput": "/results/'$1'_'$data_file'.ts", "modelInput": "/results/'$1'_'$data_file'.pkl"}' &
	    wait
        end=`date +%s.%N`
	  fi
	  
      runtime=$( echo "$end - $start" | bc -l )
      
      echo "=====================" >> $execution_log
      echo $1 >> $execution_log
      date >> $execution_log
      echo $start  >> $execution_log
      echo $end  >> $execution_log
      echo $runtime  >> $execution_log
      ((running_processes--))
  fi
}

# Function to run a R-based program and track the total number of running processes
run_program_R() {
  echo "Running alg.: $1"
  cd 2-results
  if [ -f $1_$data_file.ts ]; then
    echo $1 "done, exit"
    cd ..
    ((running_processes--))
  else   
      cd ..
      echo $1 "not executed yet"
	  
	  echo "unsupervised"
	  start=`date +%s.%N`
	  timeout 2h Rscript $1/algorithm.r '{"executionType": "execute", "dataInput": "./1-data/'$data_file'.total.csv", "dataOutput": "./2-results/adapad_'$1'_'$data_file'.ts"}' &
	  end=`date +%s.%N`
	  wait
	   
      runtime=$( echo "$end - $start" | bc -l )
      
      echo "=====================" >> $execution_log
      echo $1 >> $execution_log
      date >> $execution_log
      echo $start  >> $execution_log
      echo $end  >> $execution_log
      echo $runtime  >> $execution_log
      ((running_processes--))
  fi
}

# Function to run a R-based program and track the total number of running processes
run_program_python() {
  echo "Running alg.: $1"
  cd 2-results
  if [ -f $1_$data_file.ts ]; then
    echo $1 "done, exit"
    cd ..
    ((running_processes--))
  else   
      cd ..
      echo $1 "not executed yet"
	  
	  echo "unsupervised"
	  start=`date +%s.%N`
	  python3 $1/algorithm.py '{"executionType": "execute", "dataInput": "./1-data/'$data_file'.total.csv", "dataOutput": "./2-results/adapad_'$1'_'$data_file'.ts"}' &
	  end=`date +%s.%N`
	  wait
	   
      runtime=$( echo "$end - $start" | bc -l )
      
      echo "=====================" >> $execution_log
      echo $1 >> $execution_log
      date >> $execution_log
      echo $start  >> $execution_log
      echo $end  >> $execution_log
      echo $runtime  >> $execution_log
      ((running_processes--))
  fi
}
 
# Array of programs to run
programs_all=("adapad_valmod" "adapad_ocean_wnn" "adapad_grammarviz3" "adapad_sr_cnn" "adapad_stomp" "adapad_ts_bitmap" "adapad_bagel" "adapad_donut" "adapad_numenta_htm" "adapad_mvalmod" "adapad_stamp" "adapad_eif" "adapad_iforest" "adapad_knn" "adapad_generic_rf" "adapad_hybrid_knn" "adapad_tanogan" "adapad_cof" "adapad_subsequence_lof" "adapad_generic_xgb" "adapad_subsequence_knn" "adapad_lstm_ad" "adapad_encdec_ad" "adapad_lof" "adapad_median_method" "adapad_dspot" "adapad_torsk" "adapad_multi_subsequence_lof" "adapad_robust_pca" "adapad_hif" "adapad_novelty_svr" "adapad_phasespace_svm" "adapad_pci" "adapad_damp" "adapad_mtad_gat" "adapad_cblof" "adapad_copod" "adapad_subsequence_fast_mcd" "adapad_fast_mcd" "adapad_img_embedding_cae" "adapad_dae" "adapad_multi_hmm" "adapad_random_black_forest" "adapad_sr" "adapad_hbos" "adapad_normalizing_flows" "adapad_telemanom" "adapad_pcc" "adapad_triple_es" "adapad_lstm_vae" "adapad_laser_dbn" "adapad_dbstream" "adapad_baseline_random" "adapad_s_h_esd" "adapad_autoencoder" "adapad_baseline_normal" "adapad_deepnap" "adapad_tarzan" "adapad_sarima" "adapad_left_stampi" "adapad_mscred" "adapad_baseline_increasing" "adapad_omnianomaly" "adapad_if_lof" "adapad_kmeans" "adapad_mstamp" "adapad_hotsax" "adapad_ensemble_gi" "adapad_dwt_mlead" "adapad_subsequence_if" "adapad_deepant" "adapad_health_esn" "adapad_fft" "adapad_series2graph" "adapad_sand")

_programs=("adapad_valmod" "adapad_ocean_wnn" "adapad_grammarviz3" "adapad_sr_cnn" "adapad_stomp" "adapad_ts_bitmap" "adapad_bagel" "adapad_donut" "adapad_numenta_htm" "adapad_mvalmod" "adapad_stamp" "adapad_generic_rf" "adapad_cof" "adapad_subsequence_lof" "adapad_generic_xgb" "adapad_subsequence_knn" "adapad_median_method" "adapad_dspot" "adapad_multi_subsequence_lof" "adapad_hif" "adapad_novelty_svr" "adapad_phasespace_svm" "adapad_pci" "adapad_damp" "adapad_img_embedding_cae" "adapad_multi_hmm" "adapad_sr" "adapad_normalizing_flows" "adapad_triple_es" "adapad_baseline_random" "adapad_s_h_esd" "adapad_autoencoder" "adapad_baseline_normal" "adapad_tarzan" "adapad_sarima" "adapad_left_stampi" "adapad_baseline_increasing" "adapad_mstamp" "adapad_hotsax" "adapad_ensemble_gi" "adapad_dwt_mlead" "adapad_subsequence_if" "adapad_health_esn" "adapad_fft" "adapad_series2graph" "adapad_sand")

programs=("adapad_novelty_svr" "adapad_phasespace_svm" "adapad_ensemble_gi" "adapad_grammarviz3" "adapad_hotsax" "adapad_ts_bitmap" "adapad_left_stampi" "adapad_numenta_htm" "adapad_subsequence_lof" "adapad_subsequence_if" "adapad_dwt_mlead" "adapad_fft" "adapad_sr" "adapad_s_h_esd" "adapad_dspot" "adapad_median_method" "adapad_sarima" "adapad_triple_es" "adapad_pci" "adapad_generic_rf" "adapad_generic_xgb" "adapad_tarzan" "adapad_health_esn" "adapad_ocean_wnn" "adapad_bagel" "adapad_donut" "adapad_img_embedding_cae" "adapad_sr_cnn" "adapad_subsequence_fast_mcd" "adapad_arima" "adapad_ssa" "adapad_norma" "adapad_sand" "adapad_series2graph")

r_programs=("valmod" "stamp" "stomp" "pst")
closed_programs=("norma" "sand" "series2graph")



unsupervised=("adapad_novelty_svr" "adapad_phasespace_svm" "adapad_ensemble_gi" "adapad_grammarviz3" "adapad_hotsax" "adapad_ts_bitmap" "adapad_stamp" "adapad_stomp" "adapad_pst" "adapad_valmod" "adapad_left_stampi" "adapad_numenta_htm" "adapad_subsequence_lof" "adapad_dwt_mlead" "adapad_fft" "adapad_sr" "adapad_s_h_esd" "adapad_dspot" "adapad_median_method" "adapad_sarima" "adapad_triple_es" "adapad_pci" "adapad_pcc" "adapad_hbos" "adapad_kmeans" "adapad_knn" "adapad_eif" "adapad_torsk" "adapad_cblof" "adapad_cof" "adapad_dbstream" "adapad_lof" "adapad_copod" "adapad_if_lof" "adapad_iforest" "adapad_series2graph" "adapad_sand")
 
# Maximum number of parallel programs to run
max_parallel=20
 
# Counter for running processes
running_processes=0
 
# Iterate through the programs array
for program in "${programs[@]}"; do
  # Check if the maximum number of parallel programs is reached
  if [ $running_processes -ge $max_parallel ]; then
    # Wait for any running program to finish before launching a new one
    wait -n
  fi
 
  # Run the program in the background and track the running processes
  run_program "$program" &
  ((running_processes++))
done

# Iterate through the programs array
for program in "${r_programs[@]}"; do
  # Check if the maximum number of parallel programs is reached
  if [ $running_processes -ge $max_parallel ]; then
    # Wait for any running program to finish before launching a new one
    wait -n
  fi
 
  # Run the program in the background and track the running processes
  run_program_R "$program" &
  ((running_processes++))
done

# Iterate through the programs array
for program in "${closed_programs[@]}"; do
  # Check if the maximum number of parallel programs is reached
  if [ $running_processes -ge $max_parallel ]; then
    # Wait for any running program to finish before launching a new one
    wait -n
  fi
 
  # Run the program in the background and track the running processes
  run_program_python "$program" &
  ((running_processes++))
done
 
# Wait for all remaining programs to finish
wait
 
echo "All programs have finished running."
