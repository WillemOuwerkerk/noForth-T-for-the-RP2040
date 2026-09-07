\ RP2040 secundary boot, Forth variant no need for patches: 182 bytes

s" boot-nof" !myname

anew -targ

hex previous  forth also definitions
21000000 to MSTART      \ Start of binary
21000000 to IVECS       \ 42 vectors & default code
210000D0 to IVECS/      \ Temporary gap for .T code
210000D0 to HOT         \ Uhere starts here
\ 210000D0 to FROZEN      \ meta uhere (HOT & FROZEN are the same)
21000000 to ORIGIN      \ HERE starts here
\ ... system ...
2100F800 to FLYBUF      \ 400 bytes
2100FC00 to FLYBUF/
2100FD00 to S0          \ 100 bytes
2101FF00 to R0          \ 200 bytes
2101FF00 to TIB         \ 100 bytes
21020000 to TIB/
21020000 to BORDER      \ Systems end
21042000 to RAMTOP      \ End of user RAM

meta also definitions  forth
8000 constant R0   8001 constant R1   8002 constant R2    8003 constant R3
8004 constant R4

:::NOFORTH:::
notrace

    r0  pc ) ldr,  20042000 ##  \ Initial RP
    rp r0 mov,
  ahead,                        \ Jump to boot code!

label-amsterdam                 \ R1=lookup code, R0=rom sub address
    { lr } push,
    r2 0 # movs,
    r0  r2 14 #) ldrh,
    r2  r2 18 #) ldrh,
    r2 blx,
    { pc } pop,

  then,
\ Call rp2040 ROM functions to enable XIP (execute code in place)
    r1  pc ) ldr,  char I char F b+b  ## \ Connect internal flash
    amsterdam bl,
    r0 blx,
    r1  pc ) ldr,  char F char C b+b  ## \ Flash flush cache
    amsterdam bl,
    r0 blx,
    r1  pc ) ldr,  char C char X b+b  ## \ Flash enter cmd xip
    amsterdam bl,
    r0 blx,

\ COLD start entry for boot image: 10000046 + 1
    r1  pc ) ldr,  10000100 ##  \ R1 = Flash image address
label-amsterdam
    r2  r1 ) ldr,               \ R2 = image length
    r0  pc ) ldr,  21000000 ##  \ R0 = RAM destination address
    day r0 mov,                 \ DAY = 1st image address
    r4  0 # movs,               \ R4 = pointer, start in front!
    begin,
        r3  r1 r4 r) ldr,       \ Reading word from ROM
        r3  r0 r4 r) str,       \ Store word in RAM
        r4 4 # adds,            \ Increase pointer
        r2 r4 cmp,
    <? until,                   \ Ready when all image is copied
    sun  pc ) ldr,  10000218 ## \ Boot type cell address  *** Take care this address may change ***
    r3  sun ) ldrh,             \ Read boot type word?
    r3 0 # cmp,                 \ Single binary boot?
    =? no if,                   \ No, double binary?
        r1 r2 add,              \ Ok, calc. start of second image in R1
        r2  r1 ) ldr,           \ Read next image length to R2
        r2 0 # cmp,             \ Test length
        neg? no if,             \ Length not negative?
            r0  pc ) ldr,  21020000 ## \ Ok, set next RAM destination address
            r4  0 # movs,       \ R4 = pointer, start in front!
            begin,
                r3  r1 r4 r) ldr, \ Reading word from ROM
                r3  r0 r4 r) str, \ Store word in RAM
                r4 4 # adds,    \ Increase pointer
                r2 r4 cmp,
            <? until,           \ Ready when all image is copied
        then,
   then,
    r0 day mov,                 \ Restore address of 1st image from DAY
    r1  pc ) ldr,  E000ED08 ##  \ R1 = reset vector register (VTOR)
    r0  r1 ) str,               \ R0 = Set address of VTOR
    r1  r0 4 #) ldr,            \ R1 = First image WARM start from reset vector
    r1 bx,                      \ Jump to it

\ COLD2 start entry for spare image: 100000AA + 1
    r1  pc ) ldr,  10041000 ##  \ Second Flash image address in R1
    amsterdam 77 again,

cr .stack

chere FF 0 fill     \ Erase remainder
chere .
make-crc                        \ Add CRC to binary!!

;;;NOFORTH;;;

CHERE  to ROMHERE

make.bin

\ End
