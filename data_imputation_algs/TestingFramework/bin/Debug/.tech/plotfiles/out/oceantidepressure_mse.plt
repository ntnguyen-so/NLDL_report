set terminal postscript eps enhanced color "Helvetica" 30
set output "error/plots/oceantidepressure_mse.eps"

set xrange [58-1:464+1]
set xtics 58,58
set yrange [0:1]
#set log y

set key above width -2 vertical maxrows 3
set tmargin 4.0

set xlabel "number of missing values"
set ylabel "mean squared error" offset 1.5 

plot\
	'error/mse/MSE_brits.dat' index 0 using 1:2 title 'brits' with linespoints lt 8 dt 1 lw 2 pt 1 lc rgbcolor "black" pointsize 1.2, \
	'error/mse/MSE_m-rnn.dat' index 0 using 1:2 title 'm-rnn' with linespoints lt 8 dt 1 lw 2 pt 4 lc rgbcolor "red" pointsize 1.2, \
	'error/mse/MSE_csdipy.dat' index 0 using 1:2 title 'csdipy' with linespoints lt 8 dt 1 lw 2 pt 1 lc rgbcolor "black" pointsize 1.2, \


set output "error/plots/oceantidepressure_rmse.eps"
set ylabel "root mean squared error" offset 1.5 

plot\
	'error/rmse/RMSE_brits.dat' index 0 using 1:2 title 'brits' with linespoints lt 8 dt 1 lw 2 pt 1 lc rgbcolor "black" pointsize 1.2, \
	'error/rmse/RMSE_m-rnn.dat' index 0 using 1:2 title 'm-rnn' with linespoints lt 8 dt 1 lw 2 pt 4 lc rgbcolor "red" pointsize 1.2, \
	'error/rmse/RMSE_csdipy.dat' index 0 using 1:2 title 'csdipy' with linespoints lt 8 dt 1 lw 2 pt 1 lc rgbcolor "black" pointsize 1.2, \

set output "error/plots/oceantidepressure_mae.eps"
set ylabel "mean absolute error" offset 1.5 

plot\
	'error/mae/MAE_brits.dat' index 0 using 1:2 title 'brits' with linespoints lt 8 dt 1 lw 2 pt 1 lc rgbcolor "black" pointsize 1.2, \
	'error/mae/MAE_m-rnn.dat' index 0 using 1:2 title 'm-rnn' with linespoints lt 8 dt 1 lw 2 pt 4 lc rgbcolor "red" pointsize 1.2, \
	'error/mae/MAE_csdipy.dat' index 0 using 1:2 title 'csdipy' with linespoints lt 8 dt 1 lw 2 pt 1 lc rgbcolor "black" pointsize 1.2, \
