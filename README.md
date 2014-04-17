audioout
========

Papilio FPGA generating sine tones

These are the source files for a Xilinx ISE v14.7 project for the Papilio Pro FPGA development board with the LogicStart MegaWing.

The project makes the board into a four-component sine oscillator feeding audio through the jack on the wing, with the period of each sine controllable by the mini-joystick pushbuttons on the wing.

All the pieces (lookup table oscillator, DAC output, LED/7 segment display driver) are based on examples from the Hamsterworks FPGA intro book, http://hamsterworks.co.nz/mediawiki/index.php/FPGA_course .

audioout.vhd is the "main" file.  sineosc uses a couple of the xilinx IP blocks, a 30 bit counter and a memory.  The 1024 x 8 bit memory should be configured as simple ROM, and preloaded with the lookup table in sine.coe.

2014-04-17 Dan Ellis dpwe@ee.columbia.edu
