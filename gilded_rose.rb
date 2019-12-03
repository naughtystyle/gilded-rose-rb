class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      update_quality_for(item)
    end
  end

  private

  class Uncategorized
    def initialize(item)
      @item = item
    end

    def update_quality
      @item.sell_in.zero? ? update(-2) : update(-1)
    end

    def update(amount)
      @item.quality += amount
      @item.quality = 0 if @item.quality < 0
      @item.quality = 50 if @item.quality > 50
    end
  end

  class AgedBrie < Uncategorized
    def update_quality
      @item.sell_in.zero? ? update(2) : update(1)
    end
  end

  class Sulfuras < Uncategorized
    def update_quality
    end
  end

  class Backstage < Uncategorized
    def update_quality
      return @item.quality = 0 if @item.sell_in.zero?
      return update(3) if @item.sell_in <= 5
      return update(2) if @item.sell_in <= 10
      update(1)
    end
  end

  class Conjured < Uncategorized
    def update_quality
      2.times { super }
    end
  end

  ITEMS_VALUATION = {
    /Aged Brie/ => AgedBrie,
    /Sulfuras/ => Sulfuras,
    /Backstage pass/ => Backstage,
    /Conjured/ => Conjured,
  }

  ITEMS_VALUATION.default = Uncategorized

  def update_quality_for(item)
    ITEMS_VALUATION[category_for(item)].new(item).update_quality
  end

  def category_for(item)
    ITEMS_VALUATION.keys.find{|r| r.match(item.name) }
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
