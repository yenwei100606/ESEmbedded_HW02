HW02
===
This is the hw02 sample. Please follow the steps below.

# Build the Sample Program

1. Fork this repo to your own github account.

2. Clone the repo that you just forked.

3. Under the hw02 dir, use:

	* `make` to build.

	* `make clean` to clean the ouput files.

4. Extract `gnu-mcu-eclipse-qemu.zip` into hw02 dir. Under the path of hw02, start emulation with `make qemu`.

	See [Lecture 02 ─ Emulation with QEMU] for more details.

5. The sample is designed to help you to distinguish the main difference between the `b` and the `bl` instructions.  

	See [ESEmbedded_HW02_Example] for knowing how to do the observation and how to use markdown for taking notes.

# Build Your Own Program

1. Edit main.s.

2. Make and run like the steps above.

# HW02 Requirements

1. Please modify main.s to observe the `push` and the `pop` instructions:  

	Does the order of the registers in the `push` and the `pop` instructions affect the excution results?  

	For example, will `push {r0, r1, r2}` and `push {r2, r0, r1}` act in the same way?  

	Which register will be pushed into the stack first?

2. You have to state how you designed the observation (code), and how you performed it.  

	Just like how [ESEmbedded_HW02_Example] did.

3. If there are any official data that define the rules, you can also use them as references.

4. Push your repo to your github. (Use .gitignore to exclude the output files like object files or executable files and the qemu bin folder)

[Lecture 02 ─ Emulation with QEMU]: http://www.nc.es.ncku.edu.tw/course/embedded/02/#Emulation-with-QEMU
[ESEmbedded_HW02_Example]: https://github.com/vwxyzjimmy/ESEmbedded_HW02_Example

--------------------

- [] **If you volunteer to give the presentation next week, check this.**

--------------------

HW02 
1. 實驗題目 
改寫main.s，並且透過qemu了解push及pop指令記憶體之狀況

2. 實驗步驟
先將資料夾 gnu-mcu-eclipse-qemu 完整複製到 ESEmbedded_HW02 資料夾中

根據 ARM infomation center 敘述的 push,pop 用法改寫main.s


main.s:

_start:
        //mov
        mov r1,#1
        mov r2,#2
        mov r3,#3
        mov r4,r1

        //push
        push {r1,r2,r3,r4}


        //pop
        pop {r5,r6,r7}

        mov r5,#0
        mov r6,#0
        mov r7,#0

        push {r1,r4,r3,r2}

        pop {r7,r6,r5}
        b label01
label01:
        nop

        //
        //branch w/ link
        //
        bl      sleep

將 main.s 編譯並以 qemu 模擬， $ make clean, $ make, $ make qemu 開啟另一 Terminal 連線 $ arm-none-eabi-gdb ，再輸入 target remote localhost:1234 連接，輸入兩次的 ctrl + x 再輸入 2, 開啟 Register 以及指令，並且輸入 si 單步執行觀察。

利用mov指令，將r1,r2,r3放入整數
![](https://github.com/yenwei100606/ESEmbedded_HW02/blob/master/img/01.png)

執行0x16之後，可以發現 sp由原本的0x20000100變成0x200000f0，那是因為0x16 push{r1,r2,r3,r4}這行指令，push了4個暫存器
![](https://github.com/yenwei100606/ESEmbedded_HW02/blob/master/img/013png)
所以
0x200000fc 放r4暫存器裡面的值
0x200000f8 放r3暫存器裡面的值
0x200000f4 放r2暫存器裡面的值
0x200000f0 放r1暫存器裡面的值



![](https://github.com/yenwei100606/ESEmbedded_HW02/blob/master/img/04.png)

執行0x18 pop{r5,r6,r7}之後，sp從0x200000f0變回0x200000fc
將r1裡面的值存進r5
將r2裡面的值存進r6
將r3裡面的值存進r7
pop順序為r5,r6,r7
![](https://github.com/yenwei100606/ESEmbedded_HW02/blob/master/img/05.png)

再來可以發現，反組譯器自動將push及pop做升冪排序
![](https://github.com/yenwei100606/ESEmbedded_HW02/blob/master/img/06.png)
r5,r6,r7裡面的值為
為0x200000f0 0x200000f4 0x200000f8的值


3. 結果與討論
push及pop的順序對qemu沒影響
push的值是由上往下;pop則是由下往上，所以是FILO
