# libasm

This README is mainly for myself for learning purposes. The main project will
implement a couple of `stdlib` and `string` header functions in assembly.

Will use x86 Intel synthax assembly.

<!--toc:start-->
- [libasm](#libasm)
  - [Program structure](#program-structure)
  - [Sections](#sections)
  - [Entry point](#entry-point)
  - [Labels](#labels)
  - [Memory size specifiers](#memory-size-specifiers)
  - [Instruction format](#instruction-format)
  - [Registers (x86-64)](#registers-x86-64)
    - [Function calling convention (System V AMD64 ABI)](#function-calling-convention-system-v-amd64-abi)
  - [Syscalls (Linux x86-64)](#syscalls-linux-x86-64)
  - [syscall vs int 0x80](#syscall-vs-int-0x80)
  - [LEA and label addresses](#lea-and-label-addresses)
  - [XOR zero idiom](#xor-zero-idiom)
  - [Sign and zero extension](#sign-and-zero-extension)
  - [Build and run](#build-and-run)
<!--toc:end-->

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

## Sections

| Section | Purpose |
| --------- | --------- |
| `.text` | executable code |
| `.data` | initialized mutable data |
| `.rodata` | read-only data (string literals, constants) |
| `.bss` | uninitialized data, zero-filled at load time, costs nothing in the binary |

```asm
section .rodata
message:
    db "Hello, world", 0x0A   ; read-only: OS will segfault on accidental write

section .data
counter:
    dq 0                       ; mutable 64-bit value

section .bss
buffer resb 64                 ; reserve 64 bytes, no space used in binary
```

Use `.rodata` for string literals instead of `.data`. It is more correct and
the OS enforces the read-only protection.

## Entry point

`global` exports a label to the linker, making it visible to other object files.
Without it, the label is local to the current file.

```asm
global _start          ; entry point for a standalone binary
global ft_hello_world  ; export a function so C code can call it
global ft_strlen, ft_strcpy  ; multiple on one line
```

For a standalone binary, `_start` is the conventional name the linker looks for
as the entry point. When writing functions called from C, you do not need
`_start` since gcc provides its own entry point.

```asm
global ft_hello_world

section .text

ft_hello_world:
    ; ...
    ret
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

A label starting with `.` is local to the nearest non-dot label above it.
This scopes it to the current function and prevents name clashes across functions:

```asm
ft_strlen:
    xor rax, rax

.loop:
    cmp byte [rdi + rax], 0
    je  .done
    inc rax
    jmp .loop

.done:
    ret

ft_strcpy:
    ; .loop and .done here are separate from ft_strlen's
.loop:
    ; ...
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

## Memory size specifiers

When reading or writing memory, NASM needs to know how many bytes to access:

| Specifier | Size |
|-----------|------|
| `byte` | 1 byte |
| `word` | 2 bytes |
| `dword` | 4 bytes |
| `qword` | 8 bytes |

```asm
mov byte  [rbp - 1], 0    ; write 1 byte
mov dword [rbp - 4], 0    ; write 4 bytes (matches 32-bit registers like eax)
mov qword [rbp - 8], 0    ; write 8 bytes (matches 64-bit registers like rax)
```

Required any time the operand size cannot be inferred from a register.

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

No x86 instruction accepts two memory operands. At least one must be a register:

| Operands | Allowed |
|----------|---------|
| `<reg>, <imm>` | yes |
| `<mem>, <imm>` | yes |
| `<reg>, <reg>` | yes |
| `<reg>, <mem>` | yes |
| `<mem>, <reg>` | yes |
| `<mem>, <mem>` | no |

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

## Registers (x86-64)

64-bit general-purpose registers used for syscall arguments:

| Register | Role in syscall |
|----------|-----------------|
| `rax`    | syscall number  |
| `rdi`    | 1st argument    |
| `rsi`    | 2nd argument    |
| `rdx`    | 3rd argument    |

### Function calling convention (System V AMD64 ABI)

Registers used when calling or implementing a C function:

| Register | Role |
| ---------- | ------ |
| `rdi` | 1st argument |
| `rsi` | 2nd argument |
| `rdx` | 3rd argument |
| `rcx` | 4th argument |
| `r8` | 5th argument |
| `r9` | 6th argument |
| `rax` | return value |

Arguments beyond 6 are pushed onto the stack. The 4th argument uses `rcx`
instead of `r10` (which is what syscall uses).

Caller-saved registers: `rax`, `rcx`, `rdx`, `rsi`, `rdi`, `r8`, `r9`, `r10`,
`r11`. If a caller is using these, it must save them otherwise they might be
overwritten.

Callee-saved registers: `rbx`, `rbp`, `r12`, `r13`, `r14`, `r15`. If a
callee(function) is using these, then it must make sure they are preserved on
the stack and restored.

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

`int 0x80` works in 64-bit mode but truncates addresses to 32 bits. It will
break if your data lives above the 4GB boundary. Always use `syscall` for
64-bit code.

## LEA and label addresses

`lea` (Load Effective Address) loads an address into a register without reading
from memory. It is the way to get a label's address in a PIE binary.

```asm
mov rsi, hello_world       ; absolute address, breaks in PIE
mov rsi, [hello_world]     ; reads bytes at that address (dereference)
lea rsi, [rel hello_world] ; loads the address, RIP-relative, works in PIE
```

The `[]` brackets with `lea` are required syntax but do not cause a memory
read. `lea` only computes the address inside the brackets.

`rel` tells NASM to encode the address as an offset from the current
instruction pointer (RIP) rather than an absolute address. Since the offset
between the instruction and the label is fixed at assemble time, it stays
correct regardless of where the OS loads the binary.

gcc builds PIE by default. Always use `lea` with `rel` when loading label
addresses.

## XOR zero idiom

```asm
xor rdi, rdi   ; preferred: 3 bytes, recognized as zero idiom by CPU
mov rdi, 0     ; equivalent: 7 bytes
```

`xor reg, reg` is the idiomatic way to zero a register in x86-64. The
`sub` instruction would also work.

Further reading:
[Why do x86 compilers use `xor eax, eax` instead of `mov eax, 0`?](https://devblogs.microsoft.com/oldnewthing/20260421-00/?p=112247)

## Sign and zero extension

When widening a value from a smaller register to a larger one, the upper bits
must be filled explicitly. There are two ways depending on whether the value is signed:

| Instruction | Fills upper bits with |
|-------------|----------------------|
| `movsx` | sign bit (bit 7/15/31) |
| `movzx` | zeros |

```asm
; al = 0xE7 (-25 signed, 231 unsigned)
movsx rax, al    ; rax = 0xFFFFFFFFFFFFFFE7 (-25)
movzx rax, al    ; rax = 0x00000000000000E7 (231)
```

Without extension, the upper bytes of `rax` are whatever was there before.
For a return value this means the caller reads garbage in the upper bits.

```asm
; strcmp: subtract two bytes and return signed difference
sub al, [rsi + r8]
movsx rax, al     ; sign-extend so -25 stays -25, not 231
ret
```

```bash
nasm -f elf64 hello_world.s -o hello_world.o
ld hello_world.o -o a.out
./a.out
```
