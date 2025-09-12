local LetterTable = {}
local newText = ""

function Translate(Letter)
    local newLetter = ""
    if Letter:lower() == "!" then newLetter = "1" elseif Letter:lower() == "@" then newLetter = "2" elseif Letter:lower() == "#" then newLetter = "3" elseif Letter:lower() == "4" then newLetter = "$" elseif Letter:lower() == "%" then newLetter = "5" elseif Letter:lower() == "^" then newLetter = "6" elseif Letter:lower() == "&" then newLetter = "7" elseif Letter:lower() == "*" then newLetter = "8" elseif Letter:lower() == "(" then newLetter = "9" elseif Letter:lower() == ")" then newLetter = "0" elseif Letter:lower() == "1" then newLetter = "!" elseif Letter:lower() == "2" then newLetter = "@" elseif Letter:lower() == "3" then newLetter = "#" elseif Letter:lower() == "4" then newLetter = "$" elseif Letter:lower() == "5" then newLetter = "%" elseif Letter:lower() == "6" then newLetter = "^" elseif Letter:lower() == "7" then newLetter = "&" elseif Letter:lower() == "8" then newLetter = "*" elseif Letter:lower() == "9" then newLetter = "(" elseif Letter:lower() == "0" then newLetter = ")" elseif Letter:lower() == " " then newLetter = " " elseif Letter:lower() == "a" then newLetter = "s" elseif Letter:lower() == "b" then newLetter = "n" elseif Letter:lower() == "c" then newLetter = "v" elseif Letter:lower() == "d" then newLetter = "f" elseif Letter:lower() == "e" then newLetter = "r" elseif Letter:lower() == "f" then newLetter = "g" elseif Letter:lower() == "g" then newLetter = "h" elseif Letter:lower() == "h" then newLetter = "j" elseif Letter:lower() == "i" then newLetter = "o" elseif Letter:lower() == "j" then newLetter = "k" elseif Letter:lower() == "k" then newLetter = "l" elseif Letter:lower() == "l" then newLetter = ";" elseif Letter:lower() == "m" then newLetter = "," elseif Letter:lower() == "n" then newLetter = "m" elseif Letter:lower() == "o" then newLetter = "p" elseif Letter:lower() == "p" then newLetter = "[" elseif Letter:lower() == "q" then newLetter = "w" elseif Letter:lower() == "r" then newLetter = "t" elseif Letter:lower() == "s" then newLetter = "d" elseif Letter:lower() == "t" then newLetter = "y" elseif Letter:lower() == "u" then newLetter = "i" elseif Letter:lower() == "v" then newLetter = "b" elseif Letter:lower() == "w" then newLetter = "e" elseif Letter:lower() == "x" then newLetter = "c" elseif Letter:lower() == "y" then newLetter = "u" elseif Letter:lower() == "z" then newLetter = "x" end
    return newLetter
end

for v in _G.TranslateMessage:gmatch(".") do
    table.insert(LetterTable, v)
end

for i = 1,#LetterTable do
    newText = newText..Translate(LetterTable[i])
end

print(newText)
