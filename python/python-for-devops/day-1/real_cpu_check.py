import psutil

for i in range(5):
    print(psutil.cpu_percent(interval=1))
