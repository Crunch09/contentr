# coding: utf-8

require 'spec_helper'

class TestParagraph < Contentr::Paragraph
  field :photo, uploader: Contentr::FileUploader
  field :name, type: 'String'
end

def asset(fname)
  File.new(File.join(File.dirname(__FILE__), '..', 'assets', fname))
end

describe Contentr::Paragraph do


  it "attributes are saved properly" do
    tp = TestParagraph.new(name: "huhu!", area_name: 'foo')
    tp.save
    expect(tp.unpublished_data["name"]).to eql "huhu!"
    tp.reload
    tp.name = "hallo!"
    expect(tp.name).to eq 'hallo!'
    expect(tp.unpublished_data["name"]).to eql "huhu!"
    tp.save
    expect(tp.name).to be_nil
    expect(tp.unpublished_data['name']).to eql 'hallo!'
    tp.publish!
    expect(tp.name).to eq 'hallo!'
    expect(tp.unpublished_data['name']).to eql 'hallo!'
    tp.name = "Horst"
    expect(tp.name).to eq 'Horst'
    expect(tp.unpublished_data['name']).to eql 'hallo!'
    tp.save
    expect(tp.name).to eq 'hallo!'
    expect(tp.unpublished_data['name']).to eql 'Horst'
    tp.revert!
    expect(tp.name).to eq 'hallo!'
    expect(tp.unpublished_data['name']).to eql 'hallo!'
  end

  it "attachments" do
    tp = TestParagraph.new(name: "huhu!", area_name: 'foo')
    tp.save
    tp.name = "hallo!"
    tp.photo = asset('tenderlove.png')
    tp.save
    expect(tp.name).to be_nil
    expect(tp.photo).to_not be_present
    tp.reload

    expect(tp.unpublished_data['name']).to eql 'hallo!'
    expect(tp.name).to be_nil
    tp.publish!
    expect(tp.name).to eq 'hallo!'
    expect(tp.photo).to be_present
    expect(tp.photo.url).to match(/file\/tenderlove.png/)
    tp.photo = asset('yehuda.png')
    tp.save
    expect(tp.photo.url).to match(/tenderlove/)
    expect(tp.for_edit.photo.url).to match (/yehuda/)
    tp.publish!
    expect(tp.photo.url).to match(/yehuda/)
    tp.photo = asset('tenderlove.png')
    tp.save
    tp.revert!
    expect(tp.photo.url).to match(/file\/yehuda/)
    expect(tp.for_edit.photo.url).to match(/yehuda/)
    tp2 = TestParagraph.new(name: "aloha!", area_name: 'body')
    tp2.save
    expect(tp2.photo).to_not be_present
    tp2.photo = asset('dhh.jpg')
    tp2.save
    expect(tp2.for_edit.photo.url).to match('dhh.jpg')
    tp2.publish!
    expect(tp2.photo.url).to match(/dhh.jpg/)
    tp2.image_asset_wrapper_for("photo").remove_file!(tp2)
    tp2.save
    expect(tp2.photo.url).to match(/dhh/)
    expect(tp2.for_edit.photo).to_not be_present
    tp2.publish!
    expect(tp2.photo).to_not be_present
  end

end
