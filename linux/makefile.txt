makefile使用


.PHONY作用：
譬如 make clean 命令
如果当前目录有clean文件，则不会执行makefile中定义的规则，所以用phony来标识 伪造这个clean 

一般来说 ， make中定义可执行的的命令，都应该加到这个配置中，以防目录有重名文件冲突
