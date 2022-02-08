require 'ruby2d'
require_relative './lib/player.rb'
require_relative './lib/enemy.rb'

# single collision - DONE
# composite shapes - DONE
# enemy movement - DONE
# multiple enemies - DONE
# multiple collisions - DONE
# enemies don't overlap one another - DONE
# player shooting - DONE
# enemy shooting - DONE
# player can lose - DONE
# refactor game class
# move todos to github project
# game over screen
# can play again
# start screen
# score
# waves of enemies
# concurrency?
# high scores in the cloud
# high scores screen
# powerups
# different enemy types

background = Image.new(
    './assets/mission_background.png',
    width: Window.width,
    height: Window.height
)

@flying_bullets = []
@enemies = []

on :key_held do |event|
    case event.key
    when 'left'
        @player.move_left unless @player.at_left_edge?
    when 'right'
        @player.move_right unless @player.at_right_edge?
    when 'up'
        @player.move_forward unless @player.at_top_edge?
    when 'down'
        @player.move_backward unless @player.at_bottom_edge?
    end
end

on :key_down do |event|
    case event.key
    when 'space'
        @flying_bullets << @player.shoot
    end
end

def spawn_player
    @player = Player.new
end

def spawn_enemies
    @enemies = [
        Enemy.new(left_offset: 0, right_offset: 250),
        Enemy.new(left_offset: 50, right_offset: 200),
        Enemy.new(left_offset: 100, right_offset: 150),
        Enemy.new(left_offset: 150, right_offset: 100),
        Enemy.new(left_offset: 200, right_offset: 50),
        Enemy.new(left_offset: 250, right_offset: 0)
    ]
end

def update_bullets
    @flying_bullets.each(&:move)
    @flying_bullets.reject!(&:off_screen?)
end

def update_enemies
    @enemies.each do |enemy|
        enemy.move
        if @flying_bullets.any? { |bullet| enemy.hit_by?(bullet) }
            enemy.destroy
        end
    end

    @enemies.reject!(&:destroyed?)
end

def player_wins?
    @enemies.empty?
end

def player_hit?
    @flying_bullets.any? { |bullet| @player.hit_by?(bullet) }
end

tick = 1

spawn_player
spawn_enemies

update do
    update_bullets
    update_enemies
    @flying_bullets << @enemies.sample.shoot if tick % 60 == 0
    tick += 1
    close if player_hit? || player_wins?
end

show
