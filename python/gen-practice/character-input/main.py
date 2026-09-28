#  Excercise 1 from https://www.practicepython.org


users_name = input("Enter name: ")
users_age = int(input("Enter age: "))
loop_frequency = int(input("Enter funny-magic-mystery number: "))

#  assumes current year
user_centenary = 2026 - users_age + 100

for i in range(loop_frequency):
    print(f"Howdy {users_name}, you will turn 100 in {user_centenary}")
