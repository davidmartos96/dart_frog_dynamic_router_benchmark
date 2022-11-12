This is some benchmark code around the discussion about dynamic nested routers with `dart_frog` https://github.com/VeryGoodOpenSource/dart_frog/pull/393

From the benchmark here it appears that the router reuse strategy is 44% more performant.

## How to run

1. You need to be using the latest commit from the pull request, branch `mountedParams`
2. Compile the code with `dart compile exe bin/bench.dart -o bin/server`

3. Start the server with either of the modes: `reuse-router` or `no-reuse-router`. 
```sh
bin/server <mode>
```

4. Run the benchmark with the ApacheBench tool (ab). n is the number of requests and c is the concurrency that your PC can handle.
```sh
ab -n 50000 -c 12 http://127.0.0.1:6391/users/jack/someRandomRoute
```



# Benchmarks

## **Not reusing router (50k requests)**

### **Results**
7,922.51 req/sec

```
❯ ab -n 50000 -c 12 http://127.0.0.1:6391/users/jack/someRandomRoute

This is ApacheBench, Version 2.3 <$Revision: 1901567 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 127.0.0.1 (be patient)
Completed 5000 requests
Completed 10000 requests
Completed 15000 requests
Completed 20000 requests
Completed 25000 requests
Completed 30000 requests
Completed 35000 requests
Completed 40000 requests
Completed 45000 requests
Completed 50000 requests
Finished 50000 requests


Server Software:        
Server Hostname:        127.0.0.1
Server Port:            6391

Document Path:          /users/jack/someRandomRoute
Document Length:        15 bytes

Concurrency Level:      12
Time taken for tests:   6.311 seconds
Complete requests:      50000
Failed requests:        0
Non-2xx responses:      50000
Total transferred:      13850000 bytes
HTML transferred:       750000 bytes
Requests per second:    7922.51 [#/sec] (mean)
Time per request:       1.515 [ms] (mean)
Time per request:       0.126 [ms] (mean, across all concurrent requests)
Transfer rate:          2143.10 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       1
Processing:     0    1   0.2      1       4
Waiting:        0    1   0.1      1       4
Total:          1    1   0.2      1       4

Percentage of the requests served within a certain time (ms)
  50%      1
  66%      1
  75%      2
  80%      2
  90%      2
  95%      2
  98%      2
  99%      2
 100%      4 (longest request)
```


## **Reusing router (50k requests)**

### **Results**
11,473.36 req/sec

```
❯ ab -n 50000 -c 12 http://127.0.0.1:6391/users/jack/someRandomRoute

This is ApacheBench, Version 2.3 <$Revision: 1901567 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, http://www.zeustech.net/
Licensed to The Apache Software Foundation, http://www.apache.org/

Benchmarking 127.0.0.1 (be patient)
Completed 5000 requests
Completed 10000 requests
Completed 15000 requests
Completed 20000 requests
Completed 25000 requests
Completed 30000 requests
Completed 35000 requests
Completed 40000 requests
Completed 45000 requests
Completed 50000 requests
Finished 50000 requests


Server Software:        
Server Hostname:        127.0.0.1
Server Port:            6391

Document Path:          /users/jack/someRandomRoute
Document Length:        15 bytes

Concurrency Level:      12
Time taken for tests:   4.358 seconds
Complete requests:      50000
Failed requests:        0
Non-2xx responses:      50000
Total transferred:      13850000 bytes
HTML transferred:       750000 bytes
Requests per second:    11473.36 [#/sec] (mean)
Time per request:       1.046 [ms] (mean)
Time per request:       0.087 [ms] (mean, across all concurrent requests)
Transfer rate:          3103.63 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        0    0   0.0      0       0
Processing:     0    1   0.1      1       2
Waiting:        0    1   0.1      1       2
Total:          1    1   0.1      1       2

Percentage of the requests served within a certain time (ms)
  50%      1
  66%      1
  75%      1
  80%      1
  90%      1
  95%      1
  98%      1
  99%      1
 100%      2 (longest request)
```
