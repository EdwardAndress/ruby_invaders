class Bullet < Square
    attr_reader :x, :y
    def initialize(x:, y:, velocity:)
        @velocity = velocity
        super(x: x, y: y, size: 5, color: 'yellow')
    end

    def move
        self.y += @velocity
        remove if off_screen?
    end

    def position
        [x, y]
    end

    def off_screen?
        y < 0
    end
end