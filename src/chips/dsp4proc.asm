;Copyright (C) 1997-2008 ZSNES Team ( zsKnight, _Demo_, pagefault, Nach )
;
;http://www.zsnes.com
;http://sourceforge.net/projects/zsnes
;https://zsnes.bountysource.com
;
;This program is free software; you can redistribute it and/or
;modify it under the terms of the GNU General Public License
;version 2 as published by the Free Software Foundation.
;
;This program is distributed in the hope that it will be useful,
;but WITHOUT ANY WARRANTY; without even the implied warranty of
;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;GNU General Public License for more details.
;
;You should have received a copy of the GNU General Public License
;along with this program; if not, write to the Free Software
;Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

%include "macros.mac"

EXTSYM dsp4_address,dsp4_byte,DSP4GetByte,DSP4SetByte
EXTSYM regaccessbankr16,regaccessbankr8,regaccessbankw16,regaccessbankw8

SECTION .text

%macro RouteAccess 1
    test ecx,8000h
    jz %1
    test ecx,4000h
    jz .dsp4continue
    ret
.dsp4continue
%endmacro

NEWSYM DSP4Read8b
    RouteAccess regaccessbankr8
    mov [dsp4_address],cx
    ccallv DSP4GetByte
    mov al,[dsp4_byte]
    ret

NEWSYM DSP4Write8b
    RouteAccess regaccessbankw8
    mov [dsp4_address],cx
    mov [dsp4_byte],al
    ccallv DSP4SetByte
    ret

NEWSYM DSP4Read16b
    RouteAccess regaccessbankr16
    mov [dsp4_address],cx
    ccallv DSP4GetByte
    mov al,[dsp4_byte]
    inc word[dsp4_address]
    ccallv DSP4GetByte
    mov ah,[dsp4_byte]
    ret

NEWSYM DSP4Write16b
    RouteAccess regaccessbankw16
    mov [dsp4_address],cx
    mov [dsp4_byte],al
    ccallv DSP4SetByte
    mov [dsp4_byte],ah
    inc word[dsp4_address]
    ccallv DSP4SetByte
    ret
