        org $2000

SDLSTL  = $0230
DLIST   = $3000
SCREEN  = $3100
CHAR_C  = $0A
ptr     = 202

; --- Crear Display List manual ---
; Formato: 3 líneas de margen + 24 líneas de texto (GR.0) + JVB al inicio

start:
        lda #<DLIST         ; Apuntar SDLSTL al nuevo Display List
        sta SDLSTL
        lda #>DLIST
        sta SDLSTL+1

; Construir Display List
        ldx #0

; 3 líneas de margen (modo 2 = texto normal, 40 col)
        lda #$70
        sta DLIST,x
        inx
        sta DLIST,x
        inx
        sta DLIST,x
        inx

; 24 líneas de texto (modo 2 + LMS apuntando a SCREEN)
        lda #$42            ; Modo texto + LMS
        sta DLIST,x
        inx
        lda #<SCREEN
        sta DLIST,x
        inx
        lda #>SCREEN
        sta DLIST,x
        inx

        ldy #23             ; Ya hicimos la primera línea, faltan 23 más
line_loop:
        lda #$02            ; Modo texto normal
        sta DLIST,x
        inx
        dey
        bne line_loop

; JVB al inicio (salto para repetir Display List)
        lda #$41
        sta DLIST,x
        inx
        lda #<DLIST
        sta DLIST,x
        inx
        lda #>DLIST
        sta DLIST,x
        inx
		
		lda #<SCREEN
		sta ptr
		lda #>SCREEN
		sta ptr+1

; --- Llenar pantalla con "*" ---
        ldx #0
		ldy #0
		lda #CHAR_C
fill_loop:
        sta (ptr),y
        iny
		bne fill_loop
		
		inc ptr+1
		ldx ptr+1
		cpx #160
		bne fill_loop

; Bucle infinito
halt:
        jmp halt
