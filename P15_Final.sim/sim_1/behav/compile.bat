@echo off
rem  Vivado(TM)
rem  compile.bat: a Vivado-generated XSim simulation Script
rem  Copyright 1986-2014 Xilinx, Inc. All Rights Reserved.

set PATH=%XILINX%\lib\%PLATFORM%;%XILINX%\bin\%PLATFORM%;F:/xilin/Vivado/2014.2/ids_lite/ISE/bin/nt64;F:/xilin/Vivado/2014.2/ids_lite/ISE/lib/nt64;F:/xilin/Vivado/2014.2/bin;%PATH%
set XILINX_PLANAHEAD=F:/xilin/Vivado/2014.2

xelab -m64 --debug typical --relax -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip --snapshot mips_tb_behav --prj F:/A_Study/计算机组成原理实验/期末/P15_Final/P15_Final.sim/sim_1/behav/mips_tb.prj   xil_defaultlib.mips_tb   xil_defaultlib.glbl
if errorlevel 1 (
   cmd /c exit /b %errorlevel%
)
