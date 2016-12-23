class Color
  attr_reader :id, :code

  @@default_data = nil

  def initialize(id: nil, code: nil)
    @id = id
    @code = code
  end

  def self.load(file_path)
    @@default_data = {}
    File.open(file_path) do |file|
      YAML.load(file.read).each do |data|
        id = data[0]
        code = data[1]
        @@default_data[id] = Color.new(id: id, code: code)
      end
    end
  end

  def self.reset
    @@default_data = nil
  end

  def self.find_by_id(id)
    raise "doesn't load default data" unless self.setup?

    color = @@default_data[id]
    raise "not found #{id}" unless color

    color
  end

  def self.list
    raise "doesn't load default data" unless self.setup?

    @@default_data
  end

  def self.setup?
    !!@@default_data
  end
end
