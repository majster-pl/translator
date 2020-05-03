#!/usr/bin/python
print"HELLO!"

with open("listOfLang.txt", "r") as ins:
    array = []
    print("<country_list>")
    for line in ins:
        print("  <country>")
        print("    <name>"+line[0:-5]+"</name>")
        print("    <code>"+line[-3:-1]+"</code>")
        print("  </country>")
        #print(line[0:-5] + " ==> " + line[-3:-1])
    print("</country_list>")




