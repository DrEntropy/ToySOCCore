## Basic outline

There are many options here, in the end I decided to implement the TOY assembly language from "Computer Science" by Sedgewick.
I have made some changes:

* 8 bit words.  So each instruction will take TWO memory reads to load.  The reason for this is that my board only has 16 switches. But a secondary reason is that this is how the relay computer in Petzold's "Code" works, and I want to make sure I know how to make it go!

* The LED's will always display the results at the current memory location, so i will skip the 'show' button at first.

* I will probably use the seven segment display to show the current address or the current next TWO words (i.e. 16 bits.) NOT SURE,


## Planning

* Start with the memory and the switch loading to memory

* USE GITHUB
