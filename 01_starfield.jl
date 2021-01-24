using Luxor

function mapnumber(num, fromstart, fromstop, tostart, tostop)
    tostart + (num - fromstart) * (tostop - tostart)/(fromstop - fromstart)
end

S = 800
NFRAMES = 500
NSTARS = 400

mutable struct Star
    x
    y
    z

    prevz

    function Star()
        x = rand(-S/2:S/2)
        y = rand(-S/2:S/2)
        z = rand(1:S/2)
        prevz = z

        new(x, y, z, prevz)
    end
end

function update(scene, framenum, stars)
    origin()
    sethue("white")
    for s in stars
        s.z -= 10
        if s.z < 1
            s.z = rand(1:S/2)
            s.x = (rand() - 0.5)*S
            s.y = (rand() - 0.5)*S
            s.prevz = s.z
        end

        tx = mapnumber(s.x/s.z, -1, 1, -S/2, S/2)
        ty = mapnumber(s.y/s.z, -1, 1, -S/2, S/2)
        prevtx = mapnumber(s.x/s.prevz, -1, 1, -S/2, S/2)
        prevty = mapnumber(s.y/s.prevz, -1, 1, -S/2, S/2)
        r = mapnumber(s.z, 0, S/2, 3, 0)

        circle(tx, ty, r, :fill)
        setline(1)
        line(Point(prevtx, prevty), Point(tx, ty), :stroke)
    end
end

stars = [Star() for _ in 1:NSTARS]

field = Movie(S, S, "Starfield", 1:NFRAMES)
animate(field,
        [Scene(field, (s,f) -> background("black")),
         Scene(field, (s,f) -> update(s,f,stars))],
        creategif=true, pathname="starfield.gif")
