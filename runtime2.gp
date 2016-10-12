reset
set ylabel 'time (sec)'
set style fill solid
set title 'perfomance comparison'
set term png enhanced font 'Verdana,10'
set output 'runtime2.png'
set datafile separator ","

set xrange [:]
set yrange [:0.005]

plot 'result_clock_gettime.csv' using 1:2 smooth bezier with  lines title 'baseline',\
	'result_clock_gettime.csv' using 1:3 smooth bezier with  lines title 'OpenMP_2',\
	'result_clock_gettime.csv' using 1:4 smooth bezier with  lines title 'OpenMP_4',\
	'result_clock_gettime.csv' using 1:5 smooth bezier with  lines title 'AVX_SIMD',\
	'result_clock_gettime.csv' using 1:6 smooth bezier with  lines title 'AVX SIMD + Loop unrolling'
