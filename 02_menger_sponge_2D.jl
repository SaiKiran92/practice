using Luxor

S = 500

mutable struct MengerSponge
    pos::Point
    size
    level
end

function draw(ms::MengerSponge)
    if ms.level < 1
        return
    end

    sethue("gray")
    translate(ms.pos)
    rect(O-ms.size/2, ms.size, ms.size, :fill)
    sethue("black")
    rect(O-ms.size/6, ms.size/3, ms.size/3, :fill)
    
    for i in [-ms.size/3, 0, ms.size/3]
        for j in [-ms.size/3, 0, ms.size/3]
            if !(i == j == 0)
                draw(MengerSponge(Point(i,j), ms.size/3, ms.level-1))
            end
        end
    end
    translate(-ms.pos)
end

function update(scene, framenumber)
    origin()
    background("black")
    draw(MengerSponge(O, 500, framenumber))
end

menger = Movie(S, S, "Menger Sponge", 1:6)
animate(menger,
        [Scene(menger, (s,f) -> background("black")),
         Scene(menger, update)],
        framerate=2, creategif=true, pathname="02_menger_sponge.gif")
