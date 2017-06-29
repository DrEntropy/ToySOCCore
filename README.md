## Basic motivation

I have always wanted to wire up my own CPU, but I don't have the patience to do it with discrete components. The idea of making a simple Von Neumann architecture multicycle cpu on an FPGA I think will scratch that itch :)   The board I plan on using is the Basys 3 , which has 16 switches and corresponding LED's, as well as 5 push buttons and a 4 digit 7 segment display (among other things!)


## Instruction Set architecture

There are many options here, in the end I decided to implement the TOY assembly language from "Computer Science" by Sedgewick. It has a rich enough instruction set, but not too complicated (only 16 instructions!)

I have made some changes:

* 8 bit words.  So each instruction will take TWO memory reads to load.  The reason for this is that my board only has 16 switches. But a secondary reason is that this is how the relay computer in Petzold's "Code" works, and I want to make sure I know how to make it go!

* Input output will be OLD school via switches and LED's as in the book, but The LED's will always display the results at the current memory location, so i will skip the 'show' button at first.

* I will probably use the seven segment display to show the current address or the current next TWO words (i.e. 16 bits.) NOT SURE,

### Here is a summary of the ISA:

|Opcode  |  Descr       |   Effect               |  Format |
|--------|--------------|------------------------|---------|
|0       |Halt          |                        |         |
|1       | Add          |R[d]<-R[s]+R[t]         | RR      |
|2       | Sub          |R[d]<-R[s]-R[t]         | RR      |
|3       | And          |R[d]<-R[s]&R[t]         | RR      |
|4       | Or           |R[d]<-R[s]^R[t]         | RR      |
|5       | Shift L      |R[d]<-R[s]<<R[t]        | RR      |
|6       | Shift R      |R[d]<-R[s]>>R[t]        | RR      |
|7       | Load address | R[d] <- addr           | A       |
|8       | load         | R[d] <- M[addr]        | A       |
|9       | store        | M[addr] <- R[d]        | A       |
|A       | load indirect| R[d]<- M[R[t]]         | RR      |
|B       | store indirec| M[R[t]] <- R[d]        | RR      |
|C       | branch z     | if(R[d]==0) PC <- addr | A       |
|D       | branch pos   | if(R[d]>0) PC <- addr  | A       |
|E       | jump register| PC <- R[d]             | -       |
|F       | Jump and link| R[d]<- PC; PC <- addr  | A       |

### Formats

#### RR format
Opcode  -  d  -  s - t (all four bits)

#### A Formats
Opcode  - d  -  8 bit address



## Planning

* Start with the memory (done)

* Implement PC with built in increment (done)

* Move on to ALU and test that out. (done)

* Register file, implement and test. Needs two output and one input port.  (Done)
 (note I made sure that a zero is returned for r(0))

* Implement the IR as two seperate 8 bit registers (IRH and IRL).   After both are fetched they will contain:

IRH = Instruction + Dest Register
IRL = Source Reg 1 + Source Reg 2   |  Memory address.
(IMPLEMENTED 8 bit registers)


* Wire up the datapath, including control inputs (DONE)
Needed Muxes:
- Register file InPort = Mem out,ALU out, IRL, PC AddressOut
- Rfile OutAAddr = IRL(7 downto 4) ('s') , IRH(3 downto 0) ('d')
- PC AddressIn  = IRL , Regfile OutPortA;''
- Mem In = IRL,Regfile OutA, CPData
- Mem Address in = IRL, Reg file OutA, PCAddr, CPAddr

(CPData, and CPAddris for manual data entry, tbd)

* Wire up the control state machine (In progress)

* Test all in simulation

* Implement switch loading to memory
