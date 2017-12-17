#!/bin/sh
set -x

../quage "identity_quaternion" "identity_quaternion"

../quage "product_quaternion" "first_quaternion" "second_quaternion"

../quage "x_rotation_quaternion" "x_rotation_quaternion"
../quage "y_rotation_quaternion" "y_rotation_quaternion"
../quage "z_rotation_quaternion" "z_rotation_quaternion"

../quage "xy_z_rotation_quaternion" "x_rotation_quaternion" "y_rotation_quaternion" "z_rotation_quaternion"
../quage --reverse "x_yz_rotation_quaternion" "x_rotation_quaternion" "y_rotation_quaternion" "z_rotation_quaternion"

../quage "xz_y_rotation_quaternion" "x_rotation_quaternion" "z_rotation_quaternion" "y_rotation_quaternion"
../quage --reverse "x_zy_rotation_quaternion" "x_rotation_quaternion" "z_rotation_quaternion" "y_rotation_quaternion"

../quage "yx_z_rotation_quaternion" "y_rotation_quaternion" "x_rotation_quaternion" "z_rotation_quaternion"
../quage --reverse "y_xz_rotation_quaternion" "y_rotation_quaternion" "x_rotation_quaternion" "z_rotation_quaternion"

../quage "yz_x_rotation_quaternion" "y_rotation_quaternion" "z_rotation_quaternion" "x_rotation_quaternion"
../quage --reverse "y_zx_rotation_quaternion" "y_rotation_quaternion" "z_rotation_quaternion" "x_rotation_quaternion"

../quage "zx_y_rotation_quaternion" "z_rotation_quaternion" "x_rotation_quaternion" "y_rotation_quaternion"
../quage --reverse "z_xy_rotation_quaternion" "z_rotation_quaternion" "x_rotation_quaternion" "y_rotation_quaternion"

../quage "zy_x_rotation_quaternion" "z_rotation_quaternion" "y_rotation_quaternion" "x_rotation_quaternion"
../quage --reverse "z_yx_rotation_quaternion" "z_rotation_quaternion" "y_rotation_quaternion" "x_rotation_quaternion"
