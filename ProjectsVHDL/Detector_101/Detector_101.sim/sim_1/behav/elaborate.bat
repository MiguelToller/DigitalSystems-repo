@echo off
set xv_path=C:\\Xilinx\\Vivado\\2015.1\\bin
call %xv_path%/xelab  -wto deb9bf979aa34fedb892d1974bcbeb33 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot tb_detector_101_behav xil_defaultlib.tb_detector_101 -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
