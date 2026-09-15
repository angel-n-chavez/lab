import psutil

threshold = float(input("Enter threshold: "))

for i in range(5):
    cpu_usage = psutil.cpu_percent(interval=1)
    print(cpu_usage)

    if cpu_usage >= threshold:
        print("CPU Usage Exceeds Threshold!")
    else:
        print("CPU Usage Under Threshold")

