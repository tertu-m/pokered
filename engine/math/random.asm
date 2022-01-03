;Random_::
; Generate a random 16-bit value.
;	ldh a, [rDIV]
;	ld b, a
;	ldh a, [hRandomAdd]
;	adc b
;	ldh [hRandomAdd], a
;	ldh a, [rDIV]
;	ld b, a
;	ldh a, [hRandomSub]
;	sbc b
;	ldh [hRandomSub], a
;	ret

;Seed the random number generator.
;Slow.
;Trashes every register except c.
SeedRandom_::
    xor a
    ldh [hRNGStateCounter+1], a
    inc a
    ldh [hRNGStateCounter], a
    cpl
    ldh [hRNGStateC+1], a
    ld hl, wFrameCounter
    ld a, [hl+]
    ldh [hRNGStateA], a
    ld a, [hl]
    ldh [hRNGStateA+1], a
    ld hl, wDivCounter
    ld a, [hl+]
    ld [hRNGStateB], a
    ld a, [hl]
    ldh [hRNGStateB+1], a
    ldh a, [rDIV]
    ldh [hRNGStateC], a
    ld b, 16
.loop
    call GetRandom_
    dec b
    jr nz, .loop
	ld a, 1
	ldh [hRNGSeeded], a
    ret
