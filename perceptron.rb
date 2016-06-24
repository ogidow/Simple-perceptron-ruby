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
      @w_vec = {w1: rand(-10..10), w2: rand(-10..10), w3: rand(-10..10)}
    end
  end

  def predict (data)
    #p w_vec
    @w_vec[:w1] * 1 + @w_vec[:w2] * data[:x1] + @w_vec[:w3] * data[:x2]
  end

  def update (data)
    @w_vec = {w1: @w_vec[:w1] + @p * 1 * data[:label], w2: @w_vec[:w2] + @p * data[:x2] * data[:label], w3: @w_vec[:w3] + @p * data[:x1] * data[:label]}
  end

  def train (datas)
    update_count = 0
    datas.each do |data|
      result = predict(data)
      if result * data[:label] < 0
        update(data)
        update_count += 1
      end
    end
    update_count
  end

  def draw_graph(x1, y1, x2, y2, title)
    Gnuplot.open do |gp|
      Gnuplot::Plot.new(gp) do |plot|
        plot.xlabel "x"
        plot.ylabel "y"
        plot.title title

        plot.data << Gnuplot::DataSet.new([x1, y1]) do |ds|
          ds.with = "points"
          ds.notitle
        end

        plot.data << Gnuplot::DataSet.new([x2, y2]) do |ds|
          ds.with = "lines"
          ds.notitle
        end
      end
    end
  end

  def run
    #学習用データ作成
    init_w_vec
    datas = []
    @num_data.times do
      if rand > 0.5
        datas.push({x1: rand(1..100) * -1, x2: rand(1..100) * 1, label: 1})
      else
        datas.push({x1: rand(1..100) * 1, x2: rand(1..100) * -1, label: -1})
      end
    end

    ##学習開始
    ##収束条件：重みの更新がなくなったら
    update_count = 0
    5000.times do
      update_count = train datas
      break if update_count == 0
    end

    # w1 + x * w2 + y * w3  = 0
    # 分離直線の傾きと切片を求める
    slope = -1 * @w_vec[:w2] / @w_vec[:w3]
    interecept = -1 * @w_vec[:w1] / @w_vec[:w3]
    #学習した分離直線を出力
    puts "y = #{slope}x + #{-1 * interecept}"

    # 学習した分離直線を描画
    x =[]
    y =[]

    (-100..100).each do |i|
      x.push i
      y.push i * slope + interecept
    end

    draw_graph(datas.map{|v| v[:x1] }, datas.map{|v| v[:x2]}, x,  y, "perseptron")
  end
end

p = Perceeptron.new(0.2, 100)
p.run
