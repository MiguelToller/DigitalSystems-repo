@echo off
set xv_path=C:\\Xilinx\\Vivado\\2015.1\\bin
call %xv_path%/xelab  -wto 778a166c330e41cf9f47bb5b16e444f8 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot tb_contador_behav xil_defaultlib.tb_contador -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
