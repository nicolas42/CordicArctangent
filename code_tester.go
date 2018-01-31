package main

import (
	"fmt"
	"math"
)

// a angle

type Test struct {
	x0   int64
	y0   int64
	a0   int64
	x    int64
	y    int64
	a    int64
	xerr int64
	yerr int64
	aerr int64
}

func main() {

	// Basically only works in first quartile

	M := float64(1e18) // multiplier
	N := 60

	angles := []int64{}
	for i := 0; i <= N; i += 1 {
		angles = append(angles, int64(M*math.Atan(math.Pow(2, -float64(i)))))
	}

	tests := []Test{}
	maxError := int64(0)

	LO, HI := 1, 89
	for degrees := LO; degrees <= HI; degrees += 1 {

		radians := float64(degrees) * math.Pi / 180

		x0 := int64(math.Cos(radians) * M)
		y0 := int64(math.Sin(radians) * M)
		a0 := int64(radians * M)
		x, y := cordicA(a0)
		a := cordicV(x0, y0)
		xerr := x - x0
		yerr := y - y0
		aerr := a - a0

		tests = append(tests, Test{x0, y0, a0, x, y, a, xerr, yerr, aerr})

		// update maxError
		for _, err := range []int64{xerr, yerr, aerr} {
			if err > maxError {
				maxError = err
			}
		}
	}

	fmt.Println("Precomputed angles used in cordic")
	fmt.Println("length:", len(angles), angles, "\n")

	fmt.Println("\n=== GO/MATH CORDIC COMPARISON", "FROM", LO, "TO", HI, "DEGREES", " ===\n")
	fmt.Println("maxError:", maxError, "e-18\n")
	fmt.Println("First line go math library.  Second line cordic function.  Third line differences.")
	fmt.Println("All numbers are scaled by 1e18\n")
	fmt.Println("X \t Y \t ANGLE ")
	fmt.Println(tests)

}

func (t Test) String() string {
	return fmt.Sprintln(t.x0, t.y0, t.a0, "\n", t.x, t.y, t.a, "\n", t.xerr, t.yerr, t.aerr, "\n")
}

func cordicA(angle int64) (int64, int64) {

	M := float64(1e18) // multiplier
	N := 60
	K := 0.6072529350088812561694

	// make angles
	angles := []int64{}
	for i := 0; i <= N; i += 1 {
		angles = append(angles, int64(M*math.Atan(math.Pow(2, -float64(i)))))
	}

	// println(angle)
	x0, y0 := int64(K*M), int64(0)
	newx, newy := int64(0), int64(0)
	for i := 0; i <= N; i += 1 {
		if angle > 0 {
			// decrease angle and rotate vector counterclockwise
			newx = x0 - (y0 >> uint(i))
			newy = +(x0 >> uint(i)) + y0
			angle -= angles[uint(i)]

		} else if angle < 0 {
			// increase angle and rotate vector clockwise
			newx = x0 + (y0 >> uint(i))
			newy = -(x0 >> uint(i)) + y0
			angle += angles[uint(i)]
		}
		x0 = newx
		y0 = newy
		// fmt.Println(angle, x0,y0)

	}
	return x0, y0
}

func cordicV(x, y int64) int64 {
	// return M*atan2(y,x)
	// todo: if x=0 or y=0 return appropriate angles

	// make angles
	angles := []int64{}
	M := float64(1e18) // multiplier
	N := 60
	for i := 0; i <= N; i += 1 {
		angles = append(angles, int64(M*math.Atan(math.Pow(2, -float64(i)))))
	}

	// get absolute values of inputs
	x0, y0 := int64(0), int64(0)
	if x < 0 {
		x0 = -x
	} else {
		x0 = x
	}
	if y < 0 {
		y0 = -y
	} else {
		y0 = y
	}

	angle := int64(0)
	newx, newy := int64(0), int64(0)
	for i := 0; i <= N; i += 1 {
		if y0 > 0 {
			// rotate vector clockwise and increase angle
			newx = x0 + (y0 >> uint(i))
			newy = -(x0 >> uint(i)) + y0
			angle += angles[uint(i)]

		} else if y0 < 0 {
			// rotate vector counterclockwise and decrease angle
			newx = x0 - (y0 >> uint(i))
			newy = +(x0 >> uint(i)) + y0
			angle -= angles[uint(i)]
		}
		x0 = newx
		y0 = newy

	}

	result := int64(0)
	if x > 0 && y > 0 {
		result = angle
	} else if x < 0 && y > 0 {
		result = int64(3.14159265358979323846264338327950288419716939937510582097494459*M) - angle
	} else if x < 0 && y < 0 {
		result = -int64(3.14159265358979323846264338327950288419716939937510582097494459*M) + angle
	} else if x > 0 && y < 0 {
		result = -angle
	} else if x > 0 && y == 0 {
		result = int64(0) // fmt.Print("Oh noes ")
	} else if x == 0 && y > 0 {
		result = int64(3.14159265358979323846264338327950288419716939937510582097494459 / 2 * M) // fmt.Print("Oh noes ")
	} else if x < 0 && y == 0 {
		result = int64(3.14159265358979323846264338327950288419716939937510582097494459 * M) // fmt.Print("Oh noes ")
	} else if x == 0 && y < 0 {
		result = int64(-3.14159265358979323846264338327950288419716939937510582097494459 / 2 * M) // fmt.Print("Oh noes ")
	} else if x == 0 && y == 0 {
		result = angle // fmt.Print("Oh noes")
	}
	return result
}
