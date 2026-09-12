cpu = float(input("enter the CPU: "))  # take input from user

if cpu > 50:
    print("CPU Over Load")
elif cpu > 20 and cpu <= 50 :
    print("Send Alert")
else:
    print("CPU Normal")

