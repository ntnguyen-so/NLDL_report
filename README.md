# Description
This project contains the code used in the report of the NLDL'24 Winter School titled "Oceanographic Data Series Cleaning using Deep Learning".

The results were produced on a laptop with the CPU of Intel Core i7-1165G7 processor (8 CPU cores @ 2.80GHz) and 32GB of RAM, and operating on Ubuntu 20.04 LTS.

# Structure
The project is structured as follow:
- [anomaly_detection_algs](https://github.com/ntnguyen-so/NLDL_report/tree/main/anomaly_detection_algs): contains reproducible code for deep learning anomaly detection algorithms.
- [data_imputation_algs](https://github.com/ntnguyen-so/NLDL_report/tree/main/data_imputation_algs): contains reproducible code for deep learning data imputation algorithms.

# Reference
The code considered in this report is reused from
- anomaly_detection_algs: Schmidl, S., Wenig, P. and Papenbrock, T., 2022. Anomaly detection in time series: a comprehensive evaluation. Proceedings of the VLDB Endowment, 15(9), pp.1779-1797.
- data_imputation_algs: Mourad Khayati, Alberto Lerner, Zakhar Tymchenko, and Philippe Cudré-Mauroux. Mind the Gap: An Experimental Evaluation of Imputation of Missing Values Techniques in Time Series. Proceedings of the VLDB Endowment 13(5): 768-782, 2020.

An additional data imputation algorithm called CSDI is integrated into the framework under data_imputation_algs by the course participant. The original code is taken from Tashiro, Y., Song, J., Song, Y. and Ermon, S., 2021. Csdi: Conditional score-based diffusion models for probabilistic time series imputation. Advances in Neural Information Processing Systems, 34, pp.24804-24816. 
