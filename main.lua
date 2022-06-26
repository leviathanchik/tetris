function love.load()
    love.graphics.setBackgroundColor(0, 200, 200)
    setBackgroundImage = love.graphics.newImage("1.png")

    kubiki = {
        {
            {
                {' ', ' ', ' ', ' '},
                {'i', 'i', 'i', 'i'},
                {' ', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 'i', ' ', ' '},
                {' ', 'i', ' ', ' '},
                {' ', 'i', ' ', ' '},
                {' ', 'i', ' ', ' '},
            },
        },
        {
            {
                {' ', ' ', ' ', ' '},
                {' ', 'o', 'o', ' '},
                {' ', 'o', 'o', ' '},
                {' ', ' ', ' ', ' '},
            },
        },
        {
            {
                {' ', ' ', ' ', ' '},
                {'j', 'j', 'j', ' '},
                {' ', ' ', 'j', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', ' ', ' ', ' '},
                {' ', 'j', 'j', 'j'},
                {' ', 'j', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },

        },
        {
            {
                {' ', ' ', ' ', ' '},
                {'l', 'l', 'l', ' '},
                {'l', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 'l', ' ', ' '},
                {' ', 'l', ' ', ' '},
                {' ', 'l', 'l', ' '},
                {' ', ' ', ' ', ' '},
            },
        },
        {
            {
                {' ', ' ', ' ', ' '},
                {' ', 's', 's', ' '},
                {'s', 's', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {'s', ' ', ' ', ' '},
                {'s', 's', ' ', ' '},
                {' ', 's', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
        },
        {
            {
                {' ', ' ', ' ', ' '},
                {'z', 'z', ' ', ' '},
                {' ', 'z', 'z', ' '},
                {' ', ' ', ' ', ' '},
            },
            {
                {' ', 'z', ' ', ' '},
                {'z', 'z', ' ', ' '},
                {'z', ' ', ' ', ' '},
                {' ', ' ', ' ', ' '},
            },
        },
    }

    gridXCount = 10
    gridYCount = 20

    kubikXCount = 4
    kubikYCount = 4

    timerLimit = 0.5

    function cankubikMove(testX, testY, testRotation)
        for y = 1, kubikYCount do
            for x = 1, kubikXCount do
                local testBlockX = testX + x
                local testBlockY = testY + y

                if kubiki[kubikType][testRotation][y][x] ~= ' ' and (
                    testBlockX < 1
                    or testBlockX > gridXCount
                    or testBlockY > gridYCount
                    or inert[testBlockY][testBlockX] ~= ' '
                ) then
                    return false
                end
            end
        end

        return true
    end

    function newSequence()
        sequence = {}
        for kubikTypeIndex = 1, #kubiki do
            local position = love.math.random(#sequence + 1)
            table.insert(
                sequence,
                position,
                kubikTypeIndex
            )
        end
    end

    function newkubik()
        kubikX = 3
        kubikY = 0
        kubikRotation = 1
        kubikType = table.remove(sequence)

        if #sequence == 0 then
            newSequence()
        end
    end

    function reset()
        inert = {}
        for y = 1, gridYCount do
            inert[y] = {}
            for x = 1, gridXCount do
                inert[y][x] = ' '
            end
        end

        newSequence()
        newkubik()

        timer = 0
    end

    reset()
end
function love.update(dt)
    timer = timer + dt
    if timer >= timerLimit then
        timer = 0

        local testY = kubikY + 1
        if cankubikMove(kubikX, testY, kubikRotation) then
            kubikY = testY
        else
            for y = 1, kubikYCount do
                for x = 1, kubikXCount do
                    local block =
                        kubiki[kubikType][kubikRotation][y][x]
                    if block ~= ' ' then
                        inert[kubikY + y][kubikX + x] = block
                    end
                end
            end
            for y = 1, gridYCount do
                local complete = true
                for x = 1, gridXCount do
                    if inert[y][x] == ' ' then
                        complete = false
                        break
                    end
                end

                if complete then
                    for removeY = y, 2, -1 do
                        for removeX = 1, gridXCount do
                            inert[removeY][removeX] = inert[removeY - 1][removeX]
                        end
                    end

                    for removeX = 1, gridXCount do
                        inert[1][removeX] = ' '
                    end
                end
            end

            newkubik()

            if not cankubikMove(kubikX, kubikY, kubikRotation) then
                reset()
            end
        end
    end
end
function love.keypressed(key)
    if key == 'space' then
        local testRotation = kubikRotation + 1
        if testRotation > #kubiki[kubikType] then
            testRotation = 1
        end

        if cankubikMove(kubikX, kubikY, testRotation) then
            kubikRotation = testRotation
        end

    elseif key == 'left' then
        local testX = kubikX - 1

        if cankubikMove(testX, kubikY, kubikRotation) then
            kubikX = testX
        end

    elseif key == 'right' then
        local testX = kubikX + 1

        if cankubikMove(testX, kubikY, kubikRotation) then
            kubikX = testX
        end

    elseif key == 'down' then
        while cankubikMove(kubikX, kubikY + 1, kubikRotation) do
            kubikY = kubikY + 1
            timer = timerLimit
        end
    end
end

function love.draw()
  love.graphics.draw(setBackgroundImage, 0, 0)
    love.graphics.setColor(0, 200, 200)
    local function drawBlock(block, x, y)
        local colors = {
            [' '] = {.87, .87, .87},
            i = {.47, .76, .94},
            j = {.93, .91, .42},
            l = {.49, .85, .76},
            o = {.92, .69, .47},
            s = {.83, .54, .93},
            z = {.66, .83, .46},
            preview = {.75, .75, .75},
        }
        local color = colors[block]
        love.graphics.setColor(color)

        local blockSize = 20
        local blockDrawSize = blockSize - 1
        love.graphics.rectangle(
            'fill',
            (x - 1) * blockSize,
            (y - 1) * blockSize,
            blockDrawSize,
            blockDrawSize
        )
    end

    local offsetX = 2
    local offsetY = 5

    for y = 1, gridYCount do
        for x = 1, gridXCount do
            drawBlock(inert[y][x], x + offsetX, y + offsetY)
        end
    end

    for y = 1, kubikYCount do
        for x = 1, kubikXCount do
            local block = kubiki[kubikType][kubikRotation][y][x]
            if block ~= ' ' then
                drawBlock(block, x + kubikX + offsetX, y + kubikY + offsetY)
            end
        end
    end

    for y = 1, kubikYCount do
        for x = 1, kubikXCount do
            local block = kubiki[sequence[#sequence]][1][y][x]
            if block ~= ' ' then
                drawBlock('preview', x + 5, y + 1)
            end
        end
    end
end
