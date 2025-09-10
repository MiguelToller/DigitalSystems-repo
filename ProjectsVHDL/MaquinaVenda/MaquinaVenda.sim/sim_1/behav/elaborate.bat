@echo off
set xv_path=C:\\Xilinx\\Vivado\\2015.1\\bin
call %xv_path%/xelab  -wto 0b70e433e8e7477ba68788684af1536e -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot tb_maquina_venda_behav xil_defaultlib.tb_maquina_venda -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
