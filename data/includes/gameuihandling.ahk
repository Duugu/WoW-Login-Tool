;------------------------------------------------------------------------------------------
ScreenToUi(x, y)
{
	tA_ScreenWidth := A_ScreenWidth
	tHalfUIBarWidth   := 0
	ar := GetAR()
	if (ar > 1.77)
	{
		tA_ScreenWidth := A_ScreenHeight * 1.7777777777777777777777
		tHalfUIBarWidth := (A_ScreenWidth - tA_ScreenWidth) / 2
	}

	fUIx := 0
	oneThirdSW := tA_ScreenWidth / 3

	if(x >= (oneThirdSW * 2)) ;anchor right
	{
		fUIx := (GetUiX() * (((tA_ScreenWidth - x) / (tA_ScreenWidth / 100)) / 100)) * -1
	}
	else if(x < oneThirdSW * 2 and x > oneThirdSW) ;anchor center
	{
		fUIx := ((GetUiX() / 100) * ((x - (tA_ScreenWidth / 2)) / (tA_ScreenWidth / 100))) + 10000
	}
	else if(x <= oneThirdSW) ;anchor left
	{
		fUIx := GetUiX() * (x / tA_ScreenWidth)
	}

	Array := {X: (fUIx), Y: (768 * (y / A_ScreenHeight))}
	return Array
}

;------------------------------------------------------------------------------------------
UiToScreen(x, y)
{
	tA_ScreenWidth := A_ScreenWidth
	tHalfUIBarWidth   := 0
	ar := GetAR()
	if (ar > 1.77)
	{
		tA_ScreenWidth := A_ScreenHeight * 1.7777777777777777777777
		tHalfUIBarWidth := (A_ScreenWidth - tA_ScreenWidth) / 2
	}

	fSx := 0

	if(x >= 7000) ;anchor center
	{
		fSx := (((x - 10000) / (GetUiX() / 100)) * (tA_ScreenWidth / 100)) + (tA_ScreenWidth / 2)
	}
	else if(x <= 0) ;anchor right
	{
		fSx := tA_ScreenWidth - ((tA_ScreenWidth / 100) * ((x * -1) / (GetUiX() / 100)))
	}
	else if(x < 7000) ;anchor left
	{
		fSx := (x / (GetUiX() / 100)) * (tA_ScreenWidth / 100)
	}

	fSy := (A_ScreenHeight * (y / 768))

	if (GetAR() < 1)
	{

		PixelGetColor, color, 2, 2, RGB,
		v1blue := (color & 0xFF)
		v1green := ((color & 0xFF00) >> 8)
		v1red := ((color & 0xFF0000) >> 16)
		if (v1blue < 255 || v1green > 0 || v1red > 0)
		{
			fSy := (y * 1.334) + ((A_ScreenHeight - (768 * 1.334)) / 2)
		}
	}

	Array := {X: (fSx + tHalfUIBarWidth), Y: (fSy)}

	return Array
}

;------------------------------------------------------------------------------------------
GetAR()
{
	ar := (A_ScreenWidth) / A_ScreenHeight
	return ar
}

;------------------------------------------------------------------------------------------
GetUiX()
{
	ar := GetAR()

	if (ar < 1.34)
	{
		return 960
	}
	else if (ar < 1.49)
	{
		return 1024
	}
	else if (ar < 1.59)
	{
		return 1152
	}
	else if (ar < 1.77)
	{
		return 1228.8
	}
	else
	{
		return 1365.33
	}
}

;------------------------------------------------------------------------------------------
GetColorAtUiPos(x, y)
{
	rReturnValue := {red:-1,green:-1,blue:-1}

	tmp := UiToScreen(x, y)

	if (tmp.X > 0 and tmp.Y > 0)
	{
		PixelGetColor, color, tmp.X, tmp.Y, RGB,

		v1blue := (color & 0xFF)
		v1green := ((color & 0xFF00) >> 8)
		v1red := ((color & 0xFF0000) >> 16)

		rReturnValue := {r:v1red,g:v1green,b:v1blue}
	}

	return rReturnValue
}

