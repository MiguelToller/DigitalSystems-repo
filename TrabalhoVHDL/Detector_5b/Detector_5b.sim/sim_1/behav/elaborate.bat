@echo off
set xv_path=C:\\Xilinx\\Vivado\\2015.1\\bin
call %xv_path%/xelab  -wto b676898e1a57428f8947984c5505357a -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot tb_detector_5b_behav xil_defaultlib.tb_detector_5b -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
