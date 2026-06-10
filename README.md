# libasm

<!--toc:start-->
- [libasm](#libasm)
  - [Program structure](#program-structure)
  - [Instruction format](#instruction-format)
  - [Entry point](#entry-point)
  - [Labels](#labels)
  - [Registers (x86-64)](#registers-x86-64)
  - [Syscalls (Linux x86-64)](#syscalls-linux-x86-64)
  - [syscall vs int 0x80](#syscall-vs-int-0x80)
  - [XOR zero idiom](#xor-zero-idiom)
  - [Build and run](#build-and-run)
<!--toc:end-->

Learning x86-64 assembly (Intel syntax, NASM).

## Program structure

```asm
global _start       ; expose _start as the entry point to the linker

section .text       ; executable code lives here
_start:
    ; instructions

section .data       ; initialized data lives here
message:
    db "Hello, world", 10   ; db = define bytes, 10 = newline '\n'
```

## Instruction format

` operation [destination, source] `

The destination is always on the left, source on the right:

```asm
mov rax, 123     ; rax = 123
mov rax, rbx     ; rax = rbx
add rbx, 42      ; rbx = rbx + 42
sub rax, rcx     ; rax = rax - rcx
imul rax, rbx    ; rax = rax * rbx
xor rdi, rdi     ; rdi = 0
```

Both operands cannot be memory addresses at the same time.
At least one must be a register.

`mul` and `div` are exceptions. They only take one operand and
implicitly use `rax` and `rdx`:

```asm
; mul (unsigned multiply)
mul rbx        ; rdx:rax = rax * rbx
               ; result split: high bits in rdx, low bits in rax

; div (unsigned divide)
xor rdx, rdx   ; must clear rdx before dividing
mov rax, 100
mov rbx, 7
div rbx        ; rax = 14 (quotient), rdx = 2 (remainder)
```

`imul` and `idiv` are the signed versions.

## Entry point

The `global` keyword is used to define the entry point of the program. This
defines an identifier which makes it available to the linker. Then under this
label the processor will start executing the code.

```asm
global _start

_start:
.....

```

## Labels

A label is a name for an address in memory. The assembler replaces every use
of the label with the actual address when building the binary.

```asm
message:
    db "Hello, world", 10   ; message is the address of this data

mov rsi, message            ; rsi = address of message
```

Labels are also used for branching:

```asm
    cmp rax, 0
    je  done       ; jump to done if rax == 0
    ; ...
done:
    ; execution continues here
```

`_start` itself is just a label. It marks the address where execution begins.

Labels use a colon and point to a memory location:

```asm
message:
    db "Hello, world", 10   ; message = address of this data
```

Constants use `equ` and have no colon. Nothing is stored in memory.
The assembler replaces every use of the name with the value at assemble time:

```asm
len equ $ - message   ; len = 13, baked in at assemble time
```

The difference: `message` is an address you can pass to a register.
`len` is a number that gets substituted directly into the instruction.

`$` is a special NASM symbol that means "the current address here in
the file." The assembler evaluates it at the point where it appears:

```asm
message:
    db "Hello, world", 10
len equ $ - message   ; $ = address after the 13 bytes, so len = 13
```

`$$` means "the start of the current section."

## Registers (x86-64)

64-bit general-purpose registers used for syscall arguments:

| Register | Role in syscall |
|----------|-----------------|
| `rax`    | syscall number  |
| `rdi`    | 1st argument    |
| `rsi`    | 2nd argument    |
| `rdx`    | 3rd argument    |

## Syscalls (Linux x86-64)

A syscall hands control to the kernel to perform a privileged operation.

```asm
; sys_write (print to stdout)
mov rax, 1       ; syscall number: write
mov rdi, 1       ; fd: 1 = stdout
mov rsi, message ; pointer to buffer
mov rdx, 13      ; number of bytes to write
syscall

; sys_exit
mov rax, 60      ; syscall number: exit
xor rdi, rdi     ; exit code 0 (success)
syscall
```

Full list: [syscall table](https://syscalls.w3challs.com/?arch=x86_64)

## syscall vs int 0x80

Two ways to invoke the kernel on Linux:

| | `syscall` | `int 0x80` |
| -- | ----------- | ------------ |
| Mode | 64-bit | 32-bit |
| Args in | `rdi rsi rdx r10 r8 r9` | `ebx ecx edx esi edi ebp` |
| Syscall numbers | 64-bit table | 32-bit table (different numbers) |
| Speed | fast | slower (triggers interrupt handler) |

`int 0x80` works in 64-bit mode but truncates addresses to 32 bits — it will
break if your data lives above the 4GB boundary. Always use `syscall` for
64-bit code.

## XOR zero idiom

```asm
xor rdi, rdi   ; preferred: 3 bytes, recognized as zero idiom by CPU
mov rdi, 0     ; equivalent: 7 bytes
```

`xor reg, reg` is the idiomatic way to zero a register in x86-64. The
`sub` instruction would also work.

Further reading:
[Why do x86 compilers use `xor eax, eax` instead of `mov eax, 0`?](https://devblogs.microsoft.com/oldnewthing/20260421-00/?p=112247)

## Build and run

```bash
nasm -f elf64 hello_world.s -o hello_world.o
ld hello_world.o -o a.out
./a.out
```
