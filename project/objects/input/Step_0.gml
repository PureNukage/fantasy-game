mouseLeftPress = mouse_check_button_pressed(mb_left)
mouseLeftRelease = mouse_check_button_released(mb_left)
mouseLeft = mouse_check_button(mb_left)

mouseRightPress = mouse_check_button_pressed(mb_right)
mouseRightRelease = mouse_check_button_released(mb_right)
mouseRight = mouse_check_button(mb_right)

debugToggle = keyboard_check_pressed(vk_control)

keyUp = keyboard_check(ord("W"))
keyDown = keyboard_check(ord("S"))
keyLeft = keyboard_check(ord("A"))
keyRight = keyboard_check(ord("D"))

keyJump = keyboard_check_pressed(vk_space) or gamepad_button_check_pressed(0, gp_face1)

keyInteract = keyboard_check_pressed(ord("E")) or gamepad_button_check_pressed(0, gp_face2)

keyPause = keyboard_check_pressed(vk_escape)

keyAttack = keyboard_check_pressed(ord("Q")) or mouse_check_button_pressed(mb_left) or gamepad_button_check_pressed(0, gp_face3)
keyAttackHold = keyboard_check(ord("Q")) or mouse_check_button(mb_left) or gamepad_button_check(0,gp_face3)