![](https://github.com/senselogic/QUAGE/blob/master/LOGO/quage.png)

# Quage

Quaternion code generator.

## Examples

```bash
quage "product_quaternion" "first_quaternion" "second_quaternion"
```
```c++
product_quaternion.X = first_quaternion.W * second_quaternion.X + first_quaternion.X * second_quaternion.W + first_quaternion.Y * second_quaternion.Z - first_quaternion.Z * second_quaternion.Y;
product_quaternion.Y = first_quaternion.W * second_quaternion.Y - first_quaternion.X * second_quaternion.Z + first_quaternion.Y * second_quaternion.W + first_quaternion.Z * second_quaternion.X;
product_quaternion.Z = first_quaternion.W * second_quaternion.Z + first_quaternion.X * second_quaternion.Y - first_quaternion.Y * second_quaternion.X + first_quaternion.Z * second_quaternion.W;
product_quaternion.W = first_quaternion.W * second_quaternion.W - first_quaternion.X * second_quaternion.X - first_quaternion.Y * second_quaternion.Y - first_quaternion.Z * second_quaternion.Z;
```

```bash
quage "zx_y_rotation_quaternion" "z_rotation_quaternion" "x_rotation_quaternion" "y_rotation_quaternion"
```
```c++
zx_y_rotation_quaternion.X = half_z_cosinus * half_x_sinus * half_y_cosinus - half_z_sinus * half_x_cosinus * half_y_sinus;
zx_y_rotation_quaternion.Y = half_z_cosinus * half_x_cosinus * half_y_sinus + half_z_sinus * half_x_sinus * half_y_cosinus;
zx_y_rotation_quaternion.Z = half_z_cosinus * half_x_sinus * half_y_sinus + half_z_sinus * half_x_cosinus * half_y_cosinus;
zx_y_rotation_quaternion.W = half_z_cosinus * half_x_cosinus * half_y_cosinus - half_z_sinus * half_x_sinus * half_y_sinus;
```

```bash
quage --reverse "x_yz_rotation_quaternion" "x_rotation_quaternion" "y_rotation_quaternion" "z_rotation_quaternion"
```
```c++
x_yz_rotation_quaternion.X = half_x_cosinus * half_y_sinus * half_z_sinus + half_x_sinus * half_y_cosinus * half_z_cosinus;
x_yz_rotation_quaternion.Y = half_x_cosinus * half_y_sinus * half_z_cosinus - half_x_sinus * half_y_cosinus * half_z_sinus;
x_yz_rotation_quaternion.Z = half_x_cosinus * half_y_cosinus * half_z_sinus + half_x_sinus * half_y_sinus * half_z_cosinus;
x_yz_rotation_quaternion.W = half_x_cosinus * half_y_cosinus * half_z_cosinus - half_x_sinus * half_y_sinus * half_z_sinus;
```

## Installation

Install the [DMD 2 compiler](https://dlang.org/download.html) (using the MinGW setup option on Windows).

Build the executable with the following command line :

```bash
dmd -m64 quage.d
```

## Command line

```bash
quage [options] first_quaternion second_quaternion ...
```

### Options

```
--reverse : compute the quaternion product in reverse order
```

### Predefined quaternions

* identity_quaternion
* x_rotation_quaternion
* y_rotation_quaternion
* z_rotation_quaternion

## Named quaternions

* quaternion_name

## Version

1.0

## Author

Eric Pelzer (ecstatic.coder@gmail.com).

## License

This project is licensed under the GNU General Public License version 3.

See the [LICENSE.md](LICENSE.md) file for details.
