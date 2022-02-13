require_relative './bullet.rb'

class Enemy
    attr_accessor :x_velocity, :y_velocity

    def initialize(left_offset: 0, right_offset: 0)
        @left_offset = left_offset
        @right_offset = right_offset
        @front = Square.new(x: 2 + @left_offset, y: 36, size: 16, opacity: 0)
        @rear = Square.new(x: 0 + @left_offset, y: 20, size: 20, opacity: 0)
        @sprite = Sprite.new('./assets/enemy_sprite.png', x: 0 + @left_offset - 8, y: 16)
        @x_velocity = 2
        @direction = 1
        @status = :in_tact
    end

    def left_side
        @rear.x
    end

    def right_side
        @rear.x + @rear.size
    end

    def gun_position
        { x: @front.x + @front.size / 2, y: @front.y + @front.size }
    end

    def parts
        [@front, @rear]
    end

    def hit_by?(bullet)
        self.parts.any? { |part| part.contains?(*bullet.position) }
    end

    def destroy
        parts.each(&:remove)
        @sprite.remove
        @status = :destroyed
        Sprite.new(
            './assets/explosion_sheet.png',
            x: @sprite.x - 40,
            y: @sprite.y - 40,
            clip_width: 100,
            time: 0.1
        ).play
    end

    def destroyed?
        @status == :destroyed
    end

    def shoot
        Bullet.new(x: gun_position[:x], y: gun_position[:y], velocity: 5)
    end

    def move
        parts.each do |part|
            part.x += @x_velocity * @direction
        end

        @sprite.x += @x_velocity * @direction

        if left_side == 0 + @left_offset
            @direction = 1
        elsif right_side == Window.width - @right_offset
            @direction = -1
        end
    end
end
