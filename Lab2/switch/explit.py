target = "brainfxxk"

for char in target:
    num = ord(char) - ord("a")
    
    for i in range(num):
        print("+",end= "")
    
    print(">", end="")
        
num = ord("a")

for i in range(num):
        print("-",end= "")