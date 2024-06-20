function newCrystal(init_row, init_column, init_color)
    local self = {
        row = init_row,
        column = init_column,
        color = init_color
    }

    local getColor = function ()
        return self.color
    end

    local setColor = function (color)
        self.color = color
    end

    local getRow = function ()
        return self.row
    end

    local setRow = function (row)
        self.row = row
    end

    local getColumn = function ()
        return self.column
    end

    local setColumn = function (column)
        self.column = column
    end

    return {
        getColor = getColor,
        setColor = setColor,
        getRow = getRow,
        setRow = setRow,
        getColumn = getColumn,
        setColumn = setColumn
    }

end

function newGameModel()
    local self = {
        is_deadend = false,
        game_field = {},
        empty_cells = {}
    }

    local function checkingForExchanges()
        local mk = {}
        for i = 1, 16 do
            mk[i] = {}
            if i < 7 then
                mk[i][1] = 2
                mk[i][2] = 3
            elseif i > 6 and i < 13 then
                mk[i][1] = 3
                mk[i][2] = 2
            elseif i > 12 and i < 15 then
                mk[i][1] = 1
                mk[i][2] = 4
            else
                mk[i][1] = 4
                mk[i][2] = 1
            end
        end

        local ms = {}
        for i = 1, 16 do
            ms[i] = {}
            for j = 1, mk[i][1] do
                ms[i][j] = {}
                for k = 1, mk[i][2] do
                    ms[i][j][k] = 0
                end
            end
        end

        ms[1][1][1] = 1
        ms[1][1][2] = 1
        ms[1][2][3] = 1
        ms[2][2][1] = 1
        ms[2][2][2] = 1
        ms[2][1][3] = 1
        ms[3][1][1] = 1
        ms[3][2][2] = 1
        ms[3][1][3] = 1
        ms[4][2][1] = 1
        ms[4][1][2] = 1
        ms[4][1][3] = 1
        ms[5][1][1] = 1
        ms[5][2][2] = 1
        ms[5][2][3] = 1
        ms[6][2][1] = 1
        ms[6][1][2] = 1
        ms[6][2][3] = 1
        ms[7][1][2] = 1
        ms[7][2][2] = 1
        ms[7][3][1] = 1
        ms[8][1][1] = 1
        ms[8][2][1] = 1
        ms[8][3][2] = 1
        ms[9][1][1] = 1
        ms[9][2][2] = 1
        ms[9][3][2] = 1
        ms[10][1][2] = 1
        ms[10][2][1] = 1
        ms[10][3][1] = 1
        ms[11][1][2] = 1
        ms[11][2][1] = 1
        ms[11][3][2] = 1
        ms[12][1][1] = 1
        ms[12][2][2] = 1
        ms[12][3][1] = 1
        ms[13][1][1] = 1
        ms[13][1][2] = 1
        ms[13][1][4] = 1
        ms[14][1][1] = 1
        ms[14][1][3] = 1
        ms[14][1][4] = 1
        ms[15][1][1] = 1
        ms[15][2][1] = 1
        ms[15][4][1] = 1
        ms[16][1][1] = 1
        ms[16][3][1] = 1
        ms[16][4][1] = 1

        local count_changes = 0
        for i = 1, 6 do
            for nm = 1, 16 do
                for y = 1, 10 - mk[nm][2] + 1 do
                    for x = 1, 10 - mk[nm][1] + 1 do
                        local count_match = 0
                        for my = 1, mk[nm][2] do
                            for mx = 1, mk[nm][1] do
                                if ms[nm][mx][my] == 1 and self.game_field[y + my - 1][x + mx - 1].getColor() == i then
                                    count_match = count_match + 1
                                end
                            end
                        end
                        if count_match == 3 then
                            count_changes = count_changes + 1
                            return true
                        end
                    end
                end
            end
        end
        return false
    end

    local function rowCheck()
        local hasGroup = false
        for i = 1, 10 do
            local count_current_group = 0
            for j = 1, 10 do
                if j == 1 then
                    local current_group_color = self.game_field[i][j].getColor()
                end
                if self.game_field[i][j].getColor() == current_group_color then
                    count_current_group = count_current_group + 1
                else
                    if count_current_group > 2 then
                        hasGroup = true
                        for k = 0, count_current_group - 1 do
                            self.game_field[i][j - count_current_group + k].setColor(-1 * self.game_field[i][j - count_current_group + k].getColor())
                        end
                    end
                    current_group_color = self.game_field[i][j].getColor()
                    count_current_group = 1
                end
                if j == 10 and count_current_group > 2 then
                    for k = 1, count_current_group do
                        self.game_field[i][j - count_current_group + k].setColor(-1 * self.game_field[i][j - count_current_group + k].getColor())
                    end
                end
            end
        end
        return hasGroup
    end

    local function columnCheck()
        local hasGroup = false
        for j = 1, 10 do
            local count_current_group = 0
            for i = 1, 10 do
                if i == 1 then
                    local current_group_color = self.game_field[i][j].getColor()
                end
                if self.game_field[i][j].getColor() == current_group_color then
                    count_current_group = count_current_group + 1
                else
                    if count_current_group > 2 then
                        hasGroup = true
                        for k = 0, count_current_group - 1 do
                            self.game_field[i - count_current_group + k][j].setColor(-1 * self.game_field[i - count_current_group + k][j].getColor())
                        end
                    end
                    current_group_color = self.game_field[i][j].getColor()
                    count_current_group = 1
                end
                if i == 10 and count_current_group > 2 then
                    for k = 1, count_current_group do
                        self.game_field[i - count_current_group + k][j].setColor(-1 * self.game_field[i - count_current_group + k][j].getColor())
                    end
                end
            end
        end
        return hasGroup
    end

    local function clearCells()
        for j = 1, 10 do
            local count_empty_cells = 0
            for i = 10, 1, -1 do
                if self.game_field[i][j].getColor() < 0 then
                    count_empty_cells = count_empty_cells + 1
                    if count_empty_cells == 1 then
                        row_empty_cell = i
                    end
                end

                if self.game_field[i][j].getColor() > 0 and count_empty_cells > 0 then
                    self.game_field[row_empty_cell][j].setColor(self.game_field[i][j].getColor())
                    row_empty_cell = row_empty_cell - 1
                    self.game_field[i][j].setColor(-1)
                end
            end
        end
    end

    local function fillCells()
        for i = 1, 10 do
            for j = 1,10 do
                if self.game_field[i][j].getColor() < 0 then
                    self.game_field[i][j] = newCrystal(i, j, math.random(6))
                end
            end
        end
    end

    local dump = function ()
        --вывод поля на экран
        io.write("\n")
        for i = 1, 12 do
            for j = 1, 12 do
                if i == 1 and j > 2 then
                    io.write(j - 3)
                elseif i == 1 and j < 3 then
                    io.write(" ")
                elseif i == 2 then
                    io.write("-")
                elseif i > 2 then
                    if j == 1 then
                        io.write(i - 3)
                    elseif j == 2 then
                        io.write("|")
                    else
                        if self.game_field[i - 2][j - 2].getColor() == 1 then
                            io.write("A")
                        elseif self.game_field[i - 2][j - 2].getColor() == 2 then
                            io.write("B")
                        elseif self.game_field[i - 2][j - 2].getColor() == 3 then
                            io.write("C")
                        elseif self.game_field[i - 2][j - 2].getColor() == 4 then
                            io.write("D")
                        elseif self.game_field[i - 2][j - 2].getColor() == 5 then
                            io.write("E")
                        elseif self.game_field[i - 2][j - 2].getColor() == 6 then
                            io.write("F")
                        else
                            io.write(" ")
                        end
                    end
                end
                if j ~= 12 then
                    io.write(" ")
                else
                    io.write("\n")
                end

            end
        end
    end

    local mix = function ()
        --перемешивание поля
        self.game_field = {}
        init()

        tick()
    end

    local tick = function ()
        --выполнение действий на поле
        while rowCheck() or columnCheck() do
            clearCells()
            fillCells()
            dump()
        end

        if not checkingForExchanges() then
            mix()
        end
    end

    local init = function ()
        --создание поля(заполнение поля)
        for i = 1, 10 do
            table.insert(self.game_field, {})
            for j = 1, 10 do
                table.insert(self.game_field[i], newCrystal(i, j, math.random(6)))
            end
        end

        tick()
    end
    
    local move = function (from, to)
        --выполнение хода игрока
        local temp = self.game_field[from[2]][from[1]].getColor()
        self.game_field[from[2]][from[1]].setColor(self.game_field[to[2]][to[1]].getColor())
        self.game_field[to[2]][to[1]].setColor(temp)
    end

    return {
        init = init,
        tick = tick,
        move = move,
        mix = mix,
        dump = dump
    }
end

local function convertToCoordinates(from, to)
    local coordinates = {}
    coordinates[1] = from[1]
    coordinates[2] = from[2]
    if to == "l" then
        coordinates[1] = from[1] - 1
    end
    if to == "r" then
        coordinates[1] = from[1] + 1
    end
    if to == "u" then
        coordinates[2] = from[2] - 1
    end
    if to == "d" then
        coordinates[2] = from[2] + 1
    end
    return coordinates
end

local game_model = newGameModel()

game_model.init()
repeat
    local answer = io.read()
    local coordinates = {}
    local s = string.match(answer, "m %d %d [udlr]")
    if s ~= nil then
        for coordinate in string.gmatch(s,"%d") do
            coordinates[#coordinates + 1] = coordinate + 1
        end
        local direction = string.match(s,"[udlr]")
        if coordinates[1] == 1 and direction == "l" then
            io.write("Invalid command!")
        elseif coordinates[1] == 10 and direction == "r" then
            io.write("Invalid command!")
        elseif coordinates[2] == 1 and direction == "u" then
            io.write("Invalid command!")
        elseif coordinates[2] == 10 and direction == "d" then
            io.write("Invalid command!")
        else
            local to = convertToCoordinates(coordinates, direction)
            game_model.move(coordinates, to)
            game_model.tick()
        end
        
    elseif answer ~= "q" then
        io.write("Invalid command!")
    end
    

until answer == "q"


