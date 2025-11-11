# A simple RISC-V CPU Implementation in Verilog.

![Block Diagram for a Single-Cycle RISC-V CPU](https://raw.githubusercontent.com/bobelmasry/RISC-V-single-cycle-cpu/refs/heads/main/RISC-V%20CPU%20Block%20Diagram.png)

# Logs:

commit 89c9e1f2d518e146041e6934f59444201af80c71 (HEAD -> main, origin/main, origin/HEAD)
Author: Mohamed-Amer-1729 <arith.personal.email@gmail.com>
Date:   Tue Nov 11 18:23:25 2025 +0200

    Fixed issues with data write and memory output

commit 01eab0546e1839ab0ed248596d8b486262147b4d
Author: Mohamed-Amer-1729 <arith.personal.email@gmail.com>
Date:   Mon Nov 10 23:21:08 2025 +0200

    Debugging code in the Data memory

commit 8b8c0ec609c073e32be1a8baf2a322ba24cc12b6
Author: Mohamed-Amer-1729 <arith.personal.email@gmail.com>
Date:   Mon Nov 10 22:53:50 2025 +0200

    Added code to deal with the four special instructions

commit ca1ca7fb5e900da310a685baabe82345f423b159
Author: Mohamed-Amer-1729 <arith.personal.email@gmail.com>
Date:   Mon Nov 10 20:44:40 2025 +0200

    Updated immediate generator and fixed an issue with the branch control unit

commit 943d2750fe18b8dc5c34c5b90374a4c4e095de65
Author: Mohamed-Amer-1729 <arith.personal.email@gmail.com>
Date:   Mon Nov 10 20:29:42 2025 +0200

    Added Branch Control Unit

commit 423429195ef573912a3ea849f798c48ebd90cc95
Merge: 2915e3f 4329cc2
Author: Mohamed-Amer-1729 <arith.personal.email@gmail.com>
Date:   Mon Nov 10 19:19:50 2025 +0200

    Merge branch 'main' of https://github.com/bobelmasry/RISC-V-single-cycle-cpu

commit 2915e3f0ab11777e90a3c5ca10545c01131d881a
Author: Mohamed-Amer-1729 <arith.personal.email@gmail.com>
Date:   Mon Nov 10 19:19:44 2025 +0200

    Added ALU control Unit improvements to cover all 37 instructions

commit 4329cc2ac226e46d930294fb5d24a80960910fdd
Author: Aly Youssef <103034201+bobelmasry@users.noreply.github.com>
Date:   Mon Nov 10 18:25:20 2025 +0200

    Made Data Memory Byte-Addressable

commit 92304d8fb14c659eca06daeed19755093a4eee9a
Author: Aly Youssef <103034201+bobelmasry@users.noreply.github.com>
Date:   Mon Nov 10 17:49:07 2025 +0200

    added basic test cases

commit 1175aba7a70315325d7561e2965bceee4d567ccd
Author: Mohamed-Amer-1729 <arith.personal.email@gmail.com>
Date:   Sun Nov 9 15:28:13 2025 +0200

    Fixed a merge issue with the immediate generator

commit 4723c225e1daf4ed35bbfc855b2c3e4e7c671373
Merge: 085f45b eb41cd8
Author: Mohamed-Amer-1729 <arith.personal.email@gmail.com>
Date:   Sun Nov 9 15:15:57 2025 +0200

    Merge branch 'main' of https://github.com/bobelmasry/RISC-V-single-cycle-cpu

commit 085f45bc81f62d581b3dd59eccf7cc5988bea7f9
Author: Mohamed-Amer-1729 <arith.personal.email@gmail.com>
Date:   Sun Nov 9 15:15:53 2025 +0200

    More merge fixing

commit eb41cd804217ef360c6458384d1e90bf7e0dbc4b
Author: Aly Youssef <103034201+bobelmasry@users.noreply.github.com>
Date:   Sun Nov 9 15:14:58 2025 +0200

    Fixed spelling errors

commit 0463b5e4a6717c91e308e3344fec6cb7e715d15a
Merge: 14bfe6c 8445d0b
Author: Mohamed-Amer-1729 <arith.personal.email@gmail.com>
Date:   Sun Nov 9 14:47:16 2025 +0200

    Further merge fixes

commit 14bfe6c5287b7b75d69fe2d997a4a00f1addd66a
Merge: d2f3e3c adc4d2f
Author: Mohamed-Amer-1729 <arith.personal.email@gmail.com>
Date:   Sun Nov 9 14:44:45 2025 +0200

    Resolving merge issues

commit 8445d0bdca2b9bc6b7cdd869f6f5ddea453b8166
Merge: 4e2f8a5 adc4d2f
Author: Aly Youssef <103034201+bobelmasry@users.noreply.github.com>
Date:   Sun Nov 9 14:28:54 2025 +0200

    Merge branch 'main' of https://github.com/bobelmasry/RISC-V-single-cycle-cpu

commit 4e2f8a5c56992cade494b0db8cf4ce15e098c9b4
Author: Aly Youssef <103034201+bobelmasry@users.noreply.github.com>
Date:   Sun Nov 9 14:28:42 2025 +0200

    Added halting

commit d2f3e3ce76d5b1ef833c84d3188dc9fb07e35bc9
Author: Mohamed-Amer-1729 <arith.personal.email@gmail.com>
Date:   Sun Nov 9 14:16:52 2025 +0200

    Minor modifications to ALU code

commit adc4d2f2221629c0d413fb0f5fbff26d1598fce2
Author: Aly Youssef <103034201+bobelmasry@users.noreply.github.com>
Date:   Sun Nov 9 14:12:05 2025 +0200

    Add block diagram for single-cycle RISC-V CPU

commit 35e9e9ed962a3ab36cfd4f354fc9cb3804b1da1e
Author: Aly Youssef <103034201+bobelmasry@users.noreply.github.com>
Date:   Sun Nov 9 14:10:01 2025 +0200

    Added Block Diagram

commit 024e4c6a3868ec2b5eb4268503325b2a8b3b5d2a
Author: Aly Youssef <103034201+bobelmasry@users.noreply.github.com>
Date:   Sun Nov 9 14:07:04 2025 +0200

    Added updated ALU declaration to CPU.v

commit 5dba589343654a11d6064b50f2e19248f620eb3e
Author: Aly Youssef <103034201+bobelmasry@users.noreply.github.com>
Date:   Sun Nov 9 13:59:19 2025 +0200

    fixed syntax errors, removed unused nBitShift, added shifter needed for new ALU

commit b0e906cc1660cc2e0d2662e941c56cceaa6cbff6
Author: Mohamed-Amer-1729 <arith.personal.email@gmail.com>
Date:   Sun Nov 9 10:07:20 2025 +0200

    Added all control signals for each opcode

commit 3f49a4d2eb0d4cca9faadb6cac455a1bde5c44eb
Merge: 1835d29 0656cd5
Author: Mohamed-Amer-1729 <arith.personal.email@gmail.com>
Date:   Sun Nov 9 09:21:46 2025 +0200

    Merge branch 'main' of https://github.com/bobelmasry/RISC-V-single-cycle-cpu

commit 1835d292e8572ecaf9bcf7b37a91a095ebac4218
Author: Mohamed-Amer-1729 <arith.personal.email@gmail.com>
Date:   Sun Nov 9 09:21:43 2025 +0200

    Temp pull

commit 0656cd55100b12a9949505c455edfe06033c2131
Author: Aly Youssef <103034201+bobelmasry@users.noreply.github.com>
Date:   Fri Nov 7 11:26:29 2025 +0200

    created the random instruction generator

commit c91e82cbb1fe196fa635f8ae28a57e01383ae25e
Author: Aly Youssef <alyhassan2254@gmail.com>
Date:   Mon Nov 3 14:58:18 2025 +0200

    added defines.v and starting to add new ALU

commit df09a87e4ba7f1ef8e9a3e7e3dc44ecb801fd905
Author: Mohamed-Amer-1729 <arith.personal.email@gmail.com>
Date:   Sat Nov 1 13:23:08 2025 +0200

    Added code for testing simulation, EXP1&2

commit 80cf3a7205b742f40761656b2cec8c57226ad94a
Author: Mohamed-Amer-1729 <arith.personal.email@gmail.com>
Date:   Tue Oct 28 18:19:10 2025 +0300

    Finished up hooking CPU with debouncers and SevenSegment driver and insured correct working on board

commit 2e3111eda0aeb3010f11af7d89ed63022f93377a
Author: Aly Youssef <103034201+bobelmasry@users.noreply.github.com>
Date:   Tue Oct 28 10:22:22 2025 +0300

    added constraint file for CPU.v

commit cd59394f1da533981370a5250e1c5e56ba12056b
Author: Aly Youssef <103034201+bobelmasry@users.noreply.github.com>
Date:   Tue Oct 28 09:53:07 2025 +0300

    Added seven segment driver

commit 790e287c80374325e2eaf289bd4b604040a180fb
Author: Mohamed-Amer-1729 <arith.personal.email@gmail.com>
Date:   Mon Oct 27 16:02:25 2025 +0300

    Added file for top main level

commit db74556ffc1d84bfafbd940596bc2c382c14d346
Author: Mohamed-Amer-1729 <arith.personal.email@gmail.com>
Date:   Mon Oct 27 15:48:10 2025 +0300

    Renaming files

commit 702fc7d1a9e8dc9fffd8c7007b74c9211fb1ca46
Author: Mohamed-Amer-1729 <arith.personal.email@gmail.com>
Date:   Mon Oct 27 15:45:30 2025 +0300

    Saving last stable build

commit 0d2bebbaf86d12d35ccd7e9b58703a0ff387d498
Author: Mohamed-Amer-1729 <arith.personal.email@gmail.com>
Date:   Mon Oct 27 15:26:58 2025 +0300

    Fixed a bug related to beq ALU source signal

commit c07e467c6ed92575d486d19249d9fed87fc16ae2
Merge: 2be4937 3309684
Author: Mohamed-Amer-1729 <arith.personal.email@gmail.com>
Date:   Mon Oct 27 09:34:33 2025 +0300

    Merge branch 'main' of https://github.com/bobelmasry/RISC-V-single-cycle-cpu

commit 2be4937ad6b1bfd9a6ea8cbcacaf5efc95003074
Author: Mohamed-Amer-1729 <arith.personal.email@gmail.com>
Date:   Mon Oct 27 09:34:27 2025 +0300

    Finished coding simulation of CPU.

commit 3309684545351c1851c279f092213f62f3b7dfc3
Author: Aly Youssef <alyhassan2254@gmail.com>
Date:   Tue Oct 21 19:44:47 2025 +0300

    presumably added vga examples

commit 31116f4154148e6bd5feffaa84ed3d4909785429
Author: Aly Youssef <alyhassan2254@gmail.com>
Date:   Tue Oct 21 18:51:56 2025 +0300

    .

commit 750365579b857d24653dca597d808bcbb7875e4d
Author: Aly Youssef <alyhassan2254@gmail.com>
Date:   Tue Oct 21 18:51:40 2025 +0300

    added comments and other types of instructions

commit d94a50926ef1d7562cff70c6dd4c81ade9754cf2
Author: Aly Youssef <103034201+bobelmasry@users.noreply.github.com>
Date:   Mon Oct 20 20:38:07 2025 +0300

    removed useless comments and empty files

commit d70ef76d7a04492a271d0146d38c7041d4cbdd9f
Author: Mohamed-Amer-1729 <arith.personal.email@gmail.com>
Date:   Thu Oct 16 20:56:02 2025 +0300

    Added pre-existing files into the repo

commit 3351fbaf8ec159b86ad22db78127fa83a1d174a1
Author: Aly Youssef <103034201+bobelmasry@users.noreply.github.com>
Date:   Thu Oct 16 18:16:14 2025 +0300

    added initial config

commit 3c639c3f3f1d4df210f0d456ba9df6f025bf2732
Author: Aly Youssef <103034201+bobelmasry@users.noreply.github.com>
Date:   Thu Oct 16 18:10:14 2025 +0300

    Initial commit
