import subprocess
import shlex
import sys
import os

ss=sys.argv[1]
#print ('参数列表:', str(sys.argv))
arr=ss.split(':')

head=''
if ss.find("arren") == -1:
	head=os.getcwd()+'/'	

line=''
print(arr,len(arr))
if len(arr)==2:
	line=' --line '+arr[1]
cmd='open -na "GoLand.app" --args  '+line+' '+ head+arr[0]

print (cmd)
subprocess.call(shlex.split(cmd))
