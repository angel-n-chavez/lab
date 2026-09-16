# get system info and print out to the terminal; use funtions and appropriate data structures.

import psutil

def check_system_info():
    cpu = psutil.cpu_percent(interval=1)
    mem = psutil.virtual_memory()
    disk = psutil.disk_usage('/')

    system_info = {
        "cpu" : cpu,
        "memory" : mem,
        "disk" : disk,
    }

    return system_info
