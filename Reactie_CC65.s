
;*********************************************************************
;* REAKTIESNELHEIDSMETER VOOR KIM                                    *
;*     AUTEUR : SITO DEKKER                                          *
;*              ROSSINISTRAAT 43                                     *
;*              1962 PA  HEEMSKERK                                   *
;*                                                                   *
;*     START HET PROGRAMMA OP ADRES $0200. HET DISPLAY GAAT          *
;*     NU UIT. NA EEN RANDOM TIJD GAAT HET DISPLAY BRANDEN.          *
;*     DRUK NU ZO SNEL MOGELIJK EEN VAN DE TOETSEN 0..6 IN.          *
;*     OP HET DISPLAY VERSCHIJNT NU UW REAKTIETIJD IN MILLI_         *
;*     SECONDEN. OOK GEEFT HET                                       *
;*     PROGRAMMA EEN NIET AL TE SERIEUS COMMENTAAR. VOOR EEN         *
;*     NIEUWE POGING HOEFT U ALLEEN MAAR OP GO TE DRUKKEN.           *
;*********************************************************************

; Start the program at $0200. The Display will go blank. 
; After a random time the timer comes up. Now you should press a key 
; on the keypad from 0-6 asap.
; You will see a comment and the time you needed to push the button.
; Start over by pressing GO

; This is the original without the selfmodifying code.
; Typed in in 2025 by Nils Andreas

; Variables

DISPNR   =       $00
DISPE    =       $01
DISPT    =       $06
DISPD    =       $0d
COMP     =       $13
HULP     =       $14
COUNT    =       $15

;KIM-1 Adresses

TIMER    =       $1746
INITS    =       $1e88
KEYIN    =       $1f40
GETKEY   =       $1f6a
DISPCO   =       $1fe7

         .org    $0200
START:   lda     TIMER
         and     #$0f
         adc     #$02
         sta     DISPNR
WAITE:   jsr     KEYIN
         bne     START
         lda     #$ff
         sta     $1707
WAITT:   lda     $1707
         bpl     WAITT
         dec     DISPNR
         bne     WAITE
         ldx     #$06
STORE:   sta     DISPNR,x
         dex
         bne     STORE
         lda     #$3f
         sta     $1743
AGAIN:   lda     #$7f
         sta     $1741
         lda     #$13
         sta     DISPNR
         sed
         sec
         php
         ldx     #$06
NEXT:    cpx     #$03
         beq     KOMMA
         plp
         lda     DISPNR,x
         adc     #$00
         asl     A
         asl     A
         asl     A
         asl     A
         php
         lsr     A
         lsr     A
         lsr     A
         lsr     A
         sta     DISPNR,x
         tay
         lda     DISPCO,y
DISPLE:  ldy     #$00
         sty     $1740
         ldy     DISPNR
         sty     $1742
         sta     $1740
         dec     DISPNR
         dec     DISPNR
         ldy     #$10
LOOP:    dey
         bne     LOOP
         dex
         bne     NEXT
         plp
         lda     #$00
         sta     $1741
         lda     #$01
         sta     $1742
         nop
         lda     $1740
         and     #$7f
         eor     #$7f
         beq     AGAIN
         bne     VERDER

KOMMA:   lda     #$0c
         ldy     #$06
WAITD:   dey
         bne     WAITD
         jmp     DISPLE

VERDER:  ldx     #$06
COPY:    lda     DISPNR,x
         tay
         lda     DISPCO,y
         sta     DISPT,x
         dex
         bne     COPY
         lda     #$0c
         sta     $09
         cld
         ldy     #$0a
         lda     DISPE
         bne     DISP
         lda     $02
         bne     DISP
         lda     $04
         asl     A
         asl     A
         asl     A
         asl     A
         ora     $05
         ldy     #$00
         cmp     #$05
         bcc     DISP
         ldx     #$11
         stx     COMP
NEXTT:   iny
         jsr     COMPAR
         nop
         cmp     COMP
         bcc     DISP
         cpy     #$08
         bne     NEXTT
         nop
         nop
         bcc     DISP
         iny
DISP:    lda     #$00
ADD:     clc
         adc     #$06
         dey
         bpl     ADD
         tay
         ldx     #$05
HAALOP:  lda     L033F,y
         sta     DISPD,x
         dey
         dex
         bpl     HAALOP
DISPLT:  ldx     #$07
         jsr     WOORD
         nop
         nop
         beq     BACK
         ldx     #$0d
         jsr     WOORD
         bne     DISPLT
BACK:    jmp     START

         .byte   $ea

WOORD:   stx     L0304+1
         lda     #$80
         sta     HULP
WEEN:    lda     #$7f
         sta     $1741
         lda     #$09
         sta     COUNT
WTWEE:   lsr     A
         sbc     #$04
         tax
L0304:   lda     $07,x
         nop
         nop
         nop
         ldx     COUNT
         ldy     #$00
         sty     $1740
         stx     $1742
         sta     $1740
         ldx     #$ff
WAITV:   dex
         bne     WAITV
         inc     COUNT
         inc     COUNT
         lda     COUNT
         cmp     #$15
         bne     WTWEE
         jsr     INITS
         jsr     GETKEY
         cmp     #$13
         beq     RETURN
         dec     HULP
         bpl     WEEN
RETURN:  rts

COMPAR:  pha
         lda     COMP
         cmp     #$20
         sed
         adc     #$02
         sta     COMP
         cld
L033F:   pla
         rts

         .byte   $3d
         .byte   $79
         .byte   $38
         .byte   $3e
         .byte   $75
         .byte   $00
         .byte   $77
         .byte   $73
         .byte   $5c
         .byte   $38
         .byte   $38
         .byte   $5c
         .byte   $00
         .byte   $71
         .byte   $08
         .byte   $06
         .byte   $7d
         .byte   $00
         .byte   $00
         .byte   $3f
         .byte   $3f
         .byte   $07
         .byte   $00
         .byte   $00
         .byte   $39
         .byte   $31
         .byte   $3e
         .byte   $6e
         .byte   $71
         .byte   $00
         .byte   $00
         .byte   $6d
         .byte   $54
         .byte   $79
         .byte   $38
         .byte   $00
         .byte   $00
         .byte   $3d
         .byte   $5c
         .byte   $79
         .byte   $5e
         .byte   $00
         .byte   $78
         .byte   $31
         .byte   $77
         .byte   $77
         .byte   $3d
         .byte   $00
         .byte   $00
         .byte   $6d
         .byte   $38
         .byte   $77
         .byte   $75
         .byte   $00
         .byte   $00
         .byte   $5c
         .byte   $79
         .byte   $54
         .byte   $00
         .byte   $00
         .byte   $00
         .byte   $5e
         .byte   $31
         .byte   $5c
         .byte   $38
         .byte   $00
