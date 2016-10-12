CC = gcc
CFLAGS = -O0 -std=gnu99 -Wall -fopenmp -mavx
EXECUTABLE = \
	time_test_baseline time_test_openmp_2 time_test_openmp_4 \
	time_test_avx time_test_avxunroll \
	benchmark_clock_gettime
LAST := 20000
NUMBER := $(shell seq 100 100 ${LAST})

default: computepi.o
	$(CC) $(CFLAGS) computepi.o time_test.c -DBASELINE -o time_test_baseline
	$(CC) $(CFLAGS) computepi.o time_test.c -DOPENMP_2 -o time_test_openmp_2
	$(CC) $(CFLAGS) computepi.o time_test.c -DOPENMP_4 -o time_test_openmp_4
	$(CC) $(CFLAGS) computepi.o time_test.c -DAVX -o time_test_avx
	$(CC) $(CFLAGS) computepi.o time_test.c -DAVXUNROLL -o time_test_avxunroll
	$(CC) $(CFLAGS) computepi.o benchmark_clock_gettime.c -o benchmark_clock_gettime

.PHONY: clean default

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@ 

check: default
	time ./time_test_baseline
	time ./time_test_openmp_2
	time ./time_test_openmp_4
	time ./time_test_avx
	time ./time_test_avxunroll

gencsv: default
	for i in `seq 100 5000 25000`; do \
		printf "%d," $$i;\
		./benchmark_clock_gettime $$i; \
	done > result_clock_gettime.csv	

plot: default
	{ /usr/bin/time -f 'baseline %e %U %S' ./time_test_baseline ; } 2> time.txt
	{ /usr/bin/time -f 'openmp_2 %e %U %S' ./time_test_openmp_2 ; } 2>> time.txt
	{ /usr/bin/time -f 'openmp_4 %e %U %S' ./time_test_openmp_4 ; } 2>> time.txt
	{ /usr/bin/time -f 'avx %e %U %S' ./time_test_avx ; } 2>> time.txt
	{ /usr/bin/time -f 'avxunroll %e %U %S' ./time_test_avxunroll ; } 2>> time.txt
	gnuplot runtime.gp

plot2: default
	for i in ${NUMBER} ; do \
		printf "%d," $$i;\
		./benchmark_clock_gettime $$i; \
	done > result_clock_gettime.csv
	gnuplot runtime2.gp

clean:
	rm -f $(EXECUTABLE) *.o *.s result_clock_gettime.csv runtime.png time.txt runtime2.png
