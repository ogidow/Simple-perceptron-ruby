# y = ax + b
class Perceeptron
  def initialize(p)
    @w_vec = []
    @p = p
  end

  def init_w_vec(num_data)
    num_data.times do
      @w_vec.push({w1: rand(0.1..2.0), w2: rand(0.1..2.0)})
    end
  end

  def predict (data, w_vec)
    w_vec[:w1] * data[:x] + w_vec[:w2] * data[:y]
  end

  def update (data, w_vec)
    {w1: w_vec[:w1] + @p * data[:y] * data[:label], w2: w_vec[:w2] + @p * data[:x] * data[:label]}
  end

  def train (datas)
    datas.each_index do |idx|
      result = predict(datas[idx], @w_vec[idx])
      if result * datas[idx][:label] != 0
        @w_vec[idx] = update(datas[idx], @w_vec[idx])
      end
    end
  end

  def run
    #データ作成
    ## 第一象限にあるデータを1とする
    init_w_vec 500
    datas = []
    500.times do
      if rand > 0.5
        datas.push({x: rand(1..10), y: rand(1..10), label: 1})
      else
        datas.push({x: rand(1..10) * -1, y: rand(1..10) * -1, label: -1})
      end
    end

    5000.times do
      train datas
    end

    ## 学習できているか確認 ##
    ## 活性化関数は f(u) = u
    datas.each_index do |idx|
      result = predict(datas[idx], @w_vec[idx])
      message = "不正解"
      if result < 0
        if datas[idx][:label] == -1
          message = "正解"
        end
      else
        if datas[idx][:label] == 1
          message = "正解"
        end
      end
      puts message
    end
  end
end

p = Perceeptron.new(0.02)
p.run
