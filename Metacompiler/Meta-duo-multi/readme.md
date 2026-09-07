<h1 align="center"> Using the noForth t metacompiler</h1>

**Dual core meta:**
- Start Win32Forth
- Select the folder: Meta-duo-multi
- include T-meta-2am.f
- include T-targ-25sep25am.f
    - Type **+** key (or - key for a version without vocabularies)
    - Type **.** key
- Type: EMPTY
- include T-meta-2bm.f
- include T-targ-25sep25bm.f
    - Type **+** key (or - key for a version without vocabularies)
    - Type **.** key
          
The noForth T UF2 file is ready with the current date in the
filename, it includes sboot-nof2.bin & the generated binary
example: noforth t# duo 251010.uf2


Note the meta compiler uses these files:
- noForth-T-asm.f
- RP2040-DAS.f
- T-meta-2am.f
- T-meta-2bm.f
- T-targ-25sep25am.f
- T-targ-25sep25bm.f
- boot-nof2.bin

**Take care:**

    In the target files sometimes hard coded offsets & addresses are used.
    Especially the duo versions because they address each other too.

    FREEZE  The offset to DP, now: 0120
            also to the storage lcation for the clock frequency now: 0 CFG 2 +

    BAUD    The offset to clock frequency: CFG> 2 +
    >PLL    Idem
    CONFIG  Idem multiple time and: RAMBORDER 10A +
            Optional: RAMBORDER XXXX + BOOT1

    Check all usage of CFG and CFG> too

<h1 align="center"> Waveshare RP2040-PiZero </h1>
Uses only 3.5mA with the PLL and system clock on 48MHz and about 1.5mA on with the system clock on 16MHz.
The USB-CDC is still functioning and all timing stays correct.
<br>
