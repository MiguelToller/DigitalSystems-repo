@echo off
set xv_path=C:\\Xilinx\\Vivado\\2015.1\\bin
call %xv_path%/xelab  -wto 9e4f82462411483c9b73cf8984de0b1f -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot tb_porta_senha_behav xil_defaultlib.tb_porta_senha -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
