require File.join(File.dirname(__FILE__), "gilded_rose")

describe GildedRose do
  describe "#update_quality" do
    it "does not change the name" do
      items = [Item.new('foo', 0, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].name).not_to eq 'fixme'
    end

    it "degrades the quality of the item" do
      item = Item.new("item", 2, 2)
      gilded_rose = GildedRose.new([item])

      expect{gilded_rose.update_quality}.to change{item.quality}.from(2).to(1)
    end

    it "degrades twice as fast the quality when sell by passed" do
      item = Item.new("item", 0, 2)
      gilded_rose = GildedRose.new([item])

      expect{gilded_rose.update_quality}.to change{item.quality}.from(2).to(0)
    end
    #
    it "never has a negative quality" do
      item = Item.new("item", 0, 0)
      gilded_rose = GildedRose.new([item])

      gilded_rose.update_quality

      expect(item.quality).to eq(0)
    end

    it "never has a quality higher than 50" do
      item = Item.new("Aged Brie", 0, 50)
      gilded_rose = GildedRose.new([item])

      gilded_rose.update_quality

      expect(item.quality).to eq(50)
    end

    context "when it is Aged Brie" do
      it "increases the quality the older it gets" do
        item = Item.new("Aged Brie", 2, 2)
        gilded_rose = GildedRose.new([item])

        expect{gilded_rose.update_quality}.to change{item.quality}.from(2).to(3)
      end

      it "increases twice as fast the quality when sell by passed" do
        item = Item.new("Aged Brie", 0, 2)
        gilded_rose = GildedRose.new([item])

        expect{gilded_rose.update_quality}.to change{item.quality}.from(2).to(4)
      end
    end

    context "when it is Sulfuras" do
      it "cannot decrease in quality" do
        item = Item.new("Sulfuras, Hand of Ragnaros", 0, 80)
        gilded_rose = GildedRose.new([item])

        gilded_rose.update_quality

        expect(item.quality).to eq(80)
      end

      it "cannot be sold" do
        item = Item.new("Sulfuras, Hand of Ragnaros", 100_000, 80)
        gilded_rose = GildedRose.new([item])

        gilded_rose.update_quality

        expect(item.sell_in).to eq(100_000)
      end

      it "has a fixed quality of 80" do
        item = Item.new("Sulfuras, Hand of Ragnaros", 100_000, 80)
        gilded_rose = GildedRose.new([item])

        gilded_rose.update_quality

        expect(item.quality).to eq(80)
      end
    end

    context "when it is a Backstage Pass" do
      it "increases the quality the older it gets" do
        item = Item.new("Aged Brie", 11, 20)
        gilded_rose = GildedRose.new([item])

        expect{gilded_rose.update_quality}.to change{item.quality}.from(20).to(21)
      end

      it "drops quality when concert passed" do
        item = Item.new("Backstage passes to a TAFKAL80ETC concert", 0, 20)
        gilded_rose = GildedRose.new([item])

        gilded_rose.update_quality

        expect(item.quality).to eq(0)
      end

      it "increases quality by 3 when there are 5 days or less left" do
        item = Item.new("Backstage passes to a TAFKAL80ETC concert", 5, 20)
        gilded_rose = GildedRose.new([item])

        expect{gilded_rose.update_quality}.to change{item.quality}.from(20).to(23)
        expect{gilded_rose.update_quality}.to change{item.quality}.from(23).to(26)
        expect{gilded_rose.update_quality}.to change{item.quality}.from(26).to(29)
        expect{gilded_rose.update_quality}.to change{item.quality}.from(29).to(32)
      end

      it "increases quality by 2 when there are 10 days or less left" do
        item = Item.new("Backstage passes to a TAFKAL80ETC concert", 10, 10)
        gilded_rose = GildedRose.new([item])

        expect{gilded_rose.update_quality}.to change{item.quality}.from(10).to(12)
        expect{gilded_rose.update_quality}.to change{item.quality}.from(12).to(14)
        expect{gilded_rose.update_quality}.to change{item.quality}.from(14).to(16)
        expect{gilded_rose.update_quality}.to change{item.quality}.from(16).to(18)
        expect{gilded_rose.update_quality}.to change{item.quality}.from(18).to(20)
      end
    end

    context "when it is Conjured" do
      it "degrades the quality of the item twice" do
        item = Item.new("Conjured", 2, 2)
        gilded_rose = GildedRose.new([item])

        expect{gilded_rose.update_quality}.to change{item.quality}.from(2).to(0)
      end

      it "degrades 4 times as fast the quality when sell by passed" do
        item = Item.new("Conjured", 0, 4)
        gilded_rose = GildedRose.new([item])

        expect{gilded_rose.update_quality}.to change{item.quality}.from(4).to(0)
      end
    end
  end
end
