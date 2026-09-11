print("hello, get the fuck out")

#  variables
name = "Larry"
years_of_xp = 5
num_of_env = 3

# data type
print(type(name))
print(type(years_of_xp))
print(type(num_of_env))

# data structures - list, dict, set, tuple
env = ["dev", "stage", "prod"]  # list
print(type(env))

info = {
    "name" : "Larry",
    "years" : "5",
    "env" : ["dev", "stage", "prod"]
}

print(info["years"])  # dict
print(info)
print(type(info))

# tuple - immutable
days_of_week = ("mon", "tue", "wed", "thur", "fri", "sat", "sun")
days_of_week[2]  # wed

# set
num = {0,1,1,1,4,1,4,6,7,7,7}
print(num)
