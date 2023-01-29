require 'forwardable'
class RobotPosition
  attr_accessor :x, :y, :face
  RIGHT_CIRCULAR_FACES = ['NORTH', 'EAST', 'SOUTH', 'WEST', 'NORTH']
  LEFT_CIRCULAR_FACES = RIGHT_CIRCULAR_FACES.reverse

  def initialize(x, y, face)
    @x = x.to_i
    @y = y.to_i
    @face = face
  end

  def valid?
    @x >= 0 && @x <= 5 && @y >= 0 && @y <= 5
  end

  def move
    case face
    when 'NORTH'
      @y <= 4 ? (@y += 1) : (puts "Can't move ahead")
    when 'SOUTH'
      @y >= 1 ? (@y -= 1) : (puts "Can't move ahead")
    when 'EAST'
      @x <= 4 ? (@x += 1) : (puts "Can't move ahead")
    when 'WEST'
      @x >= 1 ? (@x -= 1) : (puts "Can't move ahead")
    end 
  end

  def left
    i = LEFT_CIRCULAR_FACES.index(@face)
    @face = LEFT_CIRCULAR_FACES[i + 1]
  end

  def right
    i = RIGHT_CIRCULAR_FACES.index(@face)
    @face = RIGHT_CIRCULAR_FACES[i + 1]
  end

  def report
    puts "#{@x},#{@y},#{@face}"
  end
end

class Robot
  extend Forwardable
  def_delegators :@position, :move, :left, :right, :report
  attr_accessor :position

  def place(x, y, face)
    pos = RobotPosition.new(x, y, face)
    if pos.valid?
      self.position = pos
    else
      puts 'Invalid Placement'
    end
  end
end

def commmand_runner(robot)
  command = gets.chomp
  case
  when command.include?('PLACE')
    x, y, face = command.split(' ')[1].split(',')
    robot.place(x, y, face)
    commmand_runner(robot)
  when command == 'MOVE'
    robot.move if !robot.position.nil?
    commmand_runner(robot)
  when command == 'LEFT'
    robot.left if !robot.position.nil?
    commmand_runner(robot)
  when command == 'RIGHT'
    robot.right if !robot.position.nil?
    commmand_runner(robot)
  when command == 'REPORT'
    robot.report if !robot.position.nil?
    commmand_runner(robot)
  when command == 'EXIT'
    puts 'Exiting'
  else
    commmand_runner(robot)
  end
end

robot = Robot.new
commmand_runner(robot)
