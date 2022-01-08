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
;Trashes every register except l.
SeedRandom_::
    ld a, 1
    ldh [hRNGStateCounter], a
    ld a, [wFrameCounter]
    ldh [hRNGStateA], a
    ld a, [wDivCounter]
    ldh [hRNGStateB], a
    ldh a, [rDIV]
    ldh [hRNGStateC], a
    ld h, 16
.loop
    call GetRandom_
    dec h
    jr nz, .loop
    ret
