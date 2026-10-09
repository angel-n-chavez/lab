num = int(input("Enter a number: "))

if num % 4 == 0:
    print(f"{num} is a multiple of 4")
elif num % 2 == 0:
    print(f"{num} is even")
else:
    print(f"{num} is odd")
