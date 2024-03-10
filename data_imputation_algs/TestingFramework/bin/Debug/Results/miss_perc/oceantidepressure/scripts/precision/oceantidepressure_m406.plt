set terminal png size 12*406,720
set output "recovery/plots/oceantidepressure_m406.png"

set xrange [29:29+406]
set xtics 0,25
#set log y

set key above width -1 vertical maxrows 2 
set tmargin 2.5

set arrow from 0,0 to 587,0 nohead

set xlabel "data point"
set ylabel "value" offset 1.5 

plot\
	'recovery/values/reference.txt' index 0 using 1:2 title 'real' with linespoints lt 1 dt 3 lw 3 pt 5 lc rgbcolor "black" pointsize 1, \
	'recovery/values/406/brits406.txt' index 0 using 1:2 title 'brits' with linespoints lt 8 dt 1 lw 2 pt 1 lc rgbcolor "black" pointsize 1.2, \
	'recovery/values/406/m-rnn406.txt' index 0 using 1:2 title 'm-rnn' with linespoints lt 8 dt 1 lw 2 pt 4 lc rgbcolor "red" pointsize 1.2, \
	'recovery/values/406/csdipy406.txt' index 0 using 1:2 title 'csdipy' with linespoints lt 8 dt 1 lw 2 pt 1 lc rgbcolor "black" pointsize 1.2, \

