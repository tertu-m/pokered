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
    push bc
    push de
    ldh a, [hRNGControl]
    and a
    jr z, .not_seeded
.seeded
    ;prevent the VBlank routine from trying to update the RNG state while we are doing it
    ldh [hRNGLock], a
    call GetRandom_
    xor a
    ldh [hRNGLock], a
    ld a, e
    pop de
    pop bc
    ret
.not_seeded
    farcall SeedRandom_
    ld a, 2
    ldh [hRNGControl], a
    jr .seeded

;Advance the random number generator
;Returns: e = the next random number
;Trashes a, b, c, d
GetRandom_::
    ldh a, [hRNGStateC]
    ld d, a
    ldh a, [hRNGStateB]
    ld b, a
    ldh a, [hRNGStateCounter]
    ld c, a
    inc a
    ldh [hRNGStateCounter], a
    ldh a, [hRNGStateA]
    add b
    add c
    ld e, a
    ld a, b
    srl b
    srl b
    xor b
    ldh [hRNGStateA], a
    ld a, d
    add a
    add d
    ldh [hRNGStateB], a
    ld a, d
    swap a
    rrca
    add e
    ldh [hRNGStateC], a 
    ret