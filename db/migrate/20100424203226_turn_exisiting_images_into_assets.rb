class TurnExisitingImagesIntoAssets < ActiveRecord::Migration
  def self.up
    Image.all.each do |image|
      image.assets.create(:attachment_url => image.image_url)
    end
  end

  def self.down
    Asset.delete_all
  end
end
