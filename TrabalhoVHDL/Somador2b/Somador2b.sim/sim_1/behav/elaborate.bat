@echo off
set xv_path=C:\\Xilinx\\Vivado\\2015.1\\bin
call %xv_path%/xelab  -wto d9a495182e48401ebcd36bb704ee49a5 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot tb_somador2b_behav xil_defaultlib.tb_somador2b -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
