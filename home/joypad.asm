ReadJoypad::
; Poll joypad input.
; Unlike the hardware register, button
; presses are indicated by a set bit.

	push hl
	ld hl, rJOYP

	ld a, 1 << 5 ; select direction keys
	call .do_read
	swap a
	ld b, a

	ld a, 1 << 4 ; select button keys
	call .do_read
	or b

	ldh [hJoyInput], a

	ld a, 1 << 4 + 1 << 5 ; deselect keys
	ld [hl], a

	pop hl
	ret

.do_read
	ld [hl], a
	call .knownret
	ld a, [hl]
	cpl
	and %1111
.knownret
	ret

Joypad::
; Update the joypad state variables:
; [hJoyReleased]  keys released since last time
; [hJoyPressed]   keys pressed since last time
; [hJoyHeld] currently pressed keys
	homecall _Joypad
	ret
