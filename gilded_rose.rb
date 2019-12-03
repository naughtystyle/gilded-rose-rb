class GildedRose
  ITEMS_VALUATION = {
    "Aged Brie" => { normal: ->(quality,_){quality + 1}, passed: ->(quality,_){quality + 2} },
    "Sulfuras, Hand of Ragnaros" => { normal: ->(_,_){80}, passed: ->(_,_){80} },
    "Backstage passes to a TAFKAL80ETC concert" => {
      normal: ->(quality, sell_in){
        return quality + 3 if sell_in <= 5
        return quality + 2 if sell_in <= 10
        quality + 1
      }, passed: ->(quality,_){0}
    },
    "Conjured" => { normal: ->(quality,_){quality - 2 }, passed: ->(quality,_){quality - 4} },
  }

  ITEMS_VALUATION.default = {
    normal: ->(quality,_){quality - 1}, passed: ->(quality,_){quality - 2}
  }

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      sell_in_status = item.sell_in.zero? ? :passed : :normal
      new_quality = ITEMS_VALUATION[item.name][sell_in_status].call(item.quality, item.sell_in)
      item.quality = new_quality unless (new_quality < 0 || new_quality > 50)
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
