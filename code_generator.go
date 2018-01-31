package main

import (
	"fmt"
	"math"
)

func main() {

	N := 60
	multiplier := float64(1e18)

	// === PRINT ANGLES DECLARATION ===
	ax := []int64{}
	for i := 0; i <= N; i += 1 {
		a := int64(multiplier * math.Atan(math.Pow(2, -float64(i))))
		fmt.Printf("%v => X\"%.16X\"", i, a)
		if i != N {
			fmt.Print(",")
		}
		fmt.Print("\n")
		ax = append(ax, a)
	}
	// fmt.Println(ax)

	// === PRINT VARIABLES DECLARATION ===
	fmt.Print("\n\n")
	fmt.Print("signal ")
	for i := 0; i <= N+1; i += 1 {
		fmt.Printf("x%v,y%v,a%v", i, i, i)
		if i != N+1 {
			fmt.Printf(", ")
		}
	}
	fmt.Print(" : signed(LEN-1 downto 0) := (others => '0');")

	//  === PRINT MAIN CODE ===
	fmt.Print("\n\n")
	for i := 0; i <= N; i += 1 {
		fmt.Printf(`
x%v <= 	x%v +shift_right(y%v,%v) when y%v > 0 else
		x%v -shift_right(y%v,%v) when y%v < 0 else 
		x%v when y%v = 0;
		
y%v <= 	-shift_right(x%v,%v) +y%v when y%v > 0 else
		shift_right(x%v,%v) +y%v when y%v < 0 else
		y%v when y%v = 0;

a%v <= 	a%v +angles(%v) when y%v > 0 else
		a%v - angles(%v) when y%v < 0 else
		a%v when y%v = 0;
`, i+1, i, i, i, i, i, i, i, i, i, i, i+1, i, i, i, i, i, i, i, i, i, i, i+1, i, i, i, i, i, i, i, i)
	}

}
