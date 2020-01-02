factor = 1.5;

run_test_benchmark_performance('xqf131.tsp', factor*564, 15000)
run_test_benchmark_performance('bcl380.tsp', factor*1621, 15000)
run_test_benchmark_performance('xql662.tsp', factor*2513, 20000)
run_test_benchmark_performance('rbx711.tsp', factor*3115, 20000)

factor = 1/0.9;

run_test_benchmark_performance('xqf131.tsp', factor*564, 100000)
run_test_benchmark_performance('bcl380.tsp', factor*1621, 100000)
run_test_benchmark_performance('xql662.tsp', factor*2513, 2000000)
run_test_benchmark_performance('rbx711.tsp', factor*3115, 1500000)