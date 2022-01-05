;Random::
; Return a random number in a.
; For battles, use BattleRandom.
;	push hl
;	push de
;	push bc
;	farcall Random_
;	ldh a, [hRandomAdd]
;	pop bc
;	pop de
;	pop hl
;	ret

;Load a random number into hRandomLow and hRandomHigh
;Returns a = hRandomHigh
;BattleRandom has been merged with this because the link
;protocol has been changed to have one side reseed its
;RNG and then copy it to the other
BattleRandom::
GetRandom::
    push hl
    push de
    ldh a, [hRNGControl]
	and a
    jr z, .not_seeded
.seeded
    call GetRandom_
    ld a, e
    ldh [hRandomLow], a
    ld a, d
    ldh [hRandomHigh],a
    pop de
    pop hl
    ret
.not_seeded
    push bc
    farcall SeedRandom_
    pop bc
	ld a, $02
	ldh [hRNGControl], a
    jr .seeded

;Advance the random number generator
;Returns: de = the next random number
;Trashes a, hl
GetRandom_::
    ldh a, [hRNGStateCounter]
    ld l, a
    add a, 1
    ldh [hRNGStateCounter], a
    ldh a, [hRNGStateCounter+1]
    ld h, a
    adc a, 0
	ldh [hRNGStateCounter+1], a
    ldh a, [hRNGStateA]
    add a, l
    ld l, a
    ldh a, [hRNGStateA+1]
    adc a, h
    ld h, a
    ldh a, [hRNGStateB+1]
    ld d, a
    ldh a, [hRNGStateB]
    ld e, a
    add hl, de
    push hl
    ld h, d
    rept 3
        srl h
        sra a
    endr
    xor e
    ldh [hRNGStateA], a    
    ld a, h
    xor d
    ldh [hRNGStateA+1], a
    ldh a, [hRNGStateC]
    ld e, a
    ld l, a
    ldh a, [hRNGStateC+1]
    ld d, a
    ld h, a
    add hl, hl
    add hl, hl
    add hl, de
    ld a, l
    ldh [hRNGStateB], a
    ld a, h
    ldh [hRNGStateB+1], a
    ld h, d
    ld a, e
	ld l, 0
    rept 4
        sla a
        rl h
		adc a, l
    endr
    ld l, a
    pop de
    add hl, de
    ld a, l
    ldh [hRNGStateC], a
    ld a, h
    ldh [hRNGStateC+1], a
    ret