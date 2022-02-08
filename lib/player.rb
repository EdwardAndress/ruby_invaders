require_relative './bullet.rb'

class Player

    def initialize
        @front = Square.new(x: 102, y: 364, size: 16, opacity: 0)
        @rear = Square.new(x: 100, y: 380, size: 20, opacity: 0)
        @sprite = Sprite.new('./assets/player_sprite.png', x: 94, y: 364)
    end

    def hit_by?(bullet)
        self.parts.any? { |part| part.contains?(*bullet.position) }
    end

    def remove
        parts.each(&:remove)
    end

    def add
        parts.each(&:add)
    end

    def parts
        [@front, @rear]
    end

    def gun_position
        { x: @front.x + @front.size / 2, y: @front.y }
    end

    def left_side
        @rear.x
    end

    def right_side
        @rear.x + @rear.size
    end

    def front_tip
        @front.y
    end

    def read_end
        @rear.y + @rear.size
    end

    def at_left_edge?
        left_side == 0
    end

    def at_right_edge?
        right_side == Window.width
    end

    def at_top_edge?
        front_tip == 0
    end

    def at_bottom_edge?
        read_end == Window.height
    end

    def shoot
        Bullet.new(
            x: gun_position[:x],
            y: gun_position[:y],
            velocity: -5
        )
    end

    def move_left
        @sprite.x -= 2
        parts.each do |part|
            part.x -= 2
        end
    end

    def move_right
        @sprite.x += 2
        parts.each do |part|
            part.x += 2
        end
    end

    def move_forward
        @sprite.y -= 2
        parts.each do |part|
            part.y -= 2
        end
    end

    def move_backward
        @sprite.y += 2
        parts.each do |part|
            part.y += 2
        end
    end
end