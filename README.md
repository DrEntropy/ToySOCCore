## Basic motivation

I have always wanted to wire up my own CPU, but I don't have the patience to do it with discrete components. Making a simple Von Neumann architecture (multi-cycle) cpu on an FPGA will scratch that itch.   The board I plan on using is the Basys 3 , on which I will use the  16 switches and corresponding LED's, as well as the push buttons.


## Instruction Set architecture

There are many options here, in the end I decided to implement the TOY assembly language from "Computer Science" by Sedgewick. It has a rich enough instruction set, but not too complicated (only 16 instructions!)

I have made some changes:

* 8 bit words.  So each instruction will take TWO memory reads to load.  The reason for this is that my board only has 16 switches. But a secondary reason is that this is how the relay computer in Petzold's "Code" works, and I want to make sure I know how to make it go!


* Opcode 0 is NOP instead of HALT.  This was just an oversight.   Instead of halt, just do endless loop at end.

* Input & output will be OLD school via switches and LED's as in the book. See below for more.

### Here is a summary of the ISA:

|Opcode  |  Descr       |   Effect               |  Format |
|--------|--------------|------------------------|---------|
|0       | NOP          |                        |         |
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

```
  IRH = Instruction + Dest Register
  IRL = Source Reg 1 + Source Reg 2   |  Memory address.
  (IMPLEMENTED 8 bit registers)
```

* Wire up the datapath, including control inputs (DONE)

Needed Muxes:
- Register file InPort = Mem out,ALU out, IRL, PC AddressOut
- Rfile OutAAddr = IRL(7 downto 4) ('s') , IRH(3 downto 0) ('d')
- PC AddressIn  = IRL , Regfile OutPortA;''
- Mem In = IRL,Regfile OutA, CPData
- Mem Address in = IRL, Reg file OutA, PCAddr, CPAddr

(CPData, and CPAddr is for manual data entry)

* Wire up the control state machine (Done, checked RTL Elaboration, works)

* Wire up TOYCore and test; (Works , discovered one accidental latch!)
    (tested using Test Program below)


* Implement switch loading to memory (done, tested in sim)

Switch loading will work like this:  The first 8 switches is the address, teh second is the data.  The lights on top correspond to same from the core.
Buttons will do this:
```
Top button: STOP = Enter "Takeover Mode"  (and hold reset to stop execution)
Bottom Button:RUN =  Leave "take over mode" and start executing
Middle button : WRITE -> Enable write of memory at selected address  with selected data on switches.
```

* Test on FPGA  (TBD)

* Test Program
```
00:r[1] <- 01   ; 7101
02:r[2] <- M[XX] ; 8212
04:r[3] <- 00  ; 7300
06:r[3] <- r[2]+r[3] ; 1323
08:r[2] <- r[2]-r[1] ; 2221
0A:if(R[2]>0) PC <- 06 ; D206
0C:M[F0] <- R[3] ; 93F0
0E:R[F]<- PC; PC <- 14 ; FF14
10:PC <- 10  ; c010
12:0C04   ; Some data
14:r[4] <- 13 ; 7413
16:r[5] <- M[r[4]] ; A504
18:r[4] <- F1;  74F1
1A:r[3] <- 02; 7302
1C:r[5] <- r[5] << r[3] ;5553
1E: M[R[4]] <- R[5]    ; B504
20:PC <- R[F]  ; EF00
```
Output is at F0, should be 78 decimal
F1 should be 10

Still doesn't test everything, but good enough for this project.
