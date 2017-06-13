## Basic motivation

I have always wanted to wire up my own CPU, but I don't have the patience to do it with discrete components. The idea of making a simple Von Neumann architecture multicycle cpu on an FPGA I think will scratch that itch :)   The board I plan on using is the Basys 3 , which has 16 switches and corresponding LED's, as well as 5 push buttons and a 4 digit 7 segment display (among other things!)


## Instruction Set architecture

There are many options here, in the end I decided to implement the TOY assembly language from "Computer Science" by Sedgewick. It has a rich enough instruction set, but not too complicated (only 16 instructions!)

I have made some changes:

* 8 bit words.  So each instruction will take TWO memory reads to load.  The reason for this is that my board only has 16 switches. But a secondary reason is that this is how the relay computer in Petzold's "Code" works, and I want to make sure I know how to make it go!

* Input output will be OLD school via switches and LED's as in the book, but The LED's will always display the results at the current memory location, so i will skip the 'show' button at first.

* I will probably use the seven segment display to show the current address or the current next TWO words (i.e. 16 bits.) NOT SURE,


## Planning

* Start with the memory and the switch loading to memory

* Implement PC with built in increment

* Move on to ALU and test that out.

* Register file, implement and test.

* Implement the IR as two seperate 8 bit registers.   After both are fetched they will contain:

IRL = Instruction + Dest Register
IRH = Source Reg 1 + Source Reg 2   |  Memory address.

* Wire up the datapath

* Wire up the control state machine
