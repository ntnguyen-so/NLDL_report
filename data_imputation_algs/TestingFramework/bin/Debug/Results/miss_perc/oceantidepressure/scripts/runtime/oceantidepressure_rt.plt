set terminal postscript eps enhanced color "Helvetica" 30
set output "runtime/plots/oceantidepressure_rt.eps"

set xrange [58:464]
set xtics 58,58
#set log y

set key above width -2 vertical maxrows 3
set tmargin 4.0

set xlabel "number of missing values"
set ylabel "running time (microseconds)" offset 1.5 

plot\
	'runtime/values/brits_runtime.txt' index 0 using 1:2 title 'brits' with linespoints lt 8 dt 1 lw 2 pt 1 lc rgbcolor "black" pointsize 1.2, \
	'runtime/values/m-rnn_runtime.txt' index 0 using 1:2 title 'm-rnn' with linespoints lt 8 dt 1 lw 2 pt 4 lc rgbcolor "red" pointsize 1.2, \
	'runtime/values/csdipy_runtime.txt' index 0 using 1:2 title 'csdipy' with linespoints lt 8 dt 1 lw 2 pt 1 lc rgbcolor "black" pointsize 1.2, \


set output "runtime/plots/oceantidepressure_rt_log.eps"
set log y

plot\
	'runtime/values/brits_runtime.txt' index 0 using 1:2 title 'brits' with linespoints lt 8 dt 1 lw 2 pt 1 lc rgbcolor "black" pointsize 1.2, \
	'runtime/values/m-rnn_runtime.txt' index 0 using 1:2 title 'm-rnn' with linespoints lt 8 dt 1 lw 2 pt 4 lc rgbcolor "red" pointsize 1.2, \
	'runtime/values/csdipy_runtime.txt' index 0 using 1:2 title 'csdipy' with linespoints lt 8 dt 1 lw 2 pt 1 lc rgbcolor "black" pointsize 1.2, \


