require "gnuplot"
# w1 + w2x + w3y = 0

class Perceeptron
  def initialize(p, num_data)
    @w_vec = {}
    @p = p
    @num_data = num_data
  end

  def init_w_vec
    @num_data.times do
      @w_vec = {w1: -20, w2: -20, w3: -20}
    end
  end

  def predict (data)
    #p w_vec
    @w_vec[:w1] * 1 + @w_vec[:w2] * data[:x] + @w_vec[:w3] * data[:y]
  end

  def update (data)
    {w1: @w_vec[:w1] + @p * 1 * data[:label], w2: @w_vec[:w2] + @p * data[:y] * data[:label], w3: @w_vec[:w3] + @p * data[:x] * data[:label]}
  end

  def train (datas)
    update_count = 0
    datas.each do |data|
      result = predict(data)
      if result * data[:label] < 0
        @w_vec = update(data)
        update_count += 1
      end
    end
    update_count
  end

  def draw_graph(x, y, title, type = "lines")
    Gnuplot.open do |gp|
      Gnuplot::Plot.new(gp) do |plot|
        plot.xlabel x[:label]
        plot.ylabel y[:label]
        plot.title title

        plot.data << Gnuplot::DataSet.new([x[:data], y[:data]]) do |ds|
          ds.with = type
          ds.notitle
        end
      end
    end
  end

  def run
    #データ作成
    ## 第一象限にあるデータを1とする
    init_w_vec
    datas = []
    @num_data.times do
      if rand > 0.5
        datas.push({x: rand(1..10) * 1, y: rand(1..10) * 1, label: 1})
      else
        datas.push({x: rand(1..10) * -1, y: rand(1..10) * -1, label: -1})
      end
    end

    ##学習開始
    ##収束条件：重みの更新を必要としなくなった場合収束
    update_count = 0
    loop do
      update_count = train datas
      break if update_count == 0
    end

    ## 学習できているか確認 ##
    ## 活性化関数は f(u) = u
    test_data = []
    @num_data.times do
      if rand > 0.5
        test_data.push({x: rand(1..100), y: rand(1..100), label: 1})
      else
        test_data.push({x: rand(1..100) * -1, y: rand(1..100) * -1, label: -1})
      end
    end
    true_count = 0
    test_data.each do |data|
      result = predict(data)
      message = "不正解"
      #puts result
      if result * data[:label] > 0
        message = "正解"
        true_count += 1
      end

      puts message
    end
    # w1 + x * w2 + y * w3  = 0
    puts "正解率 : #{(true_count / test_data.length.to_f)}"
    puts "y = #{-1 * @w_vec[:w2] / @w_vec[:w3]}x + #{-1 * @w_vec[:w1] / @w_vec[:w3]}"
    p @w_vec
    draw_graph({data: datas.map{|v| v[:x] }, label: "xlabel"}, {data: datas.map{|v| v[:y]}, label: "ylabel"}, "perseptron", "points")
  end
end

p = Perceeptron.new(0.2, 100)
p.run
