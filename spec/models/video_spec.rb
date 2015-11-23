require 'spec_helper'

describe Video do
  it {should belong_to (:category)}
  it {should validate_presence_of (:title)}
  it {should validate_presence_of (:description)}

  describe "search_by_title" do
    it "returns an empty array when there's no match" do
      expect(Video.search_by_title("some title")).to eq([])
    end

    it "returns an array of one video when there's a perfect match" do
      vid = Video.create(title: "some title", description: "some description")
      expect(Video.search_by_title("#{vid.title}")).to eq([vid])
    end 
    
    it "returns an array of one video when there's a partial match" do
      str = "some string"
      vid1 = Video.create(title: "#{str} abc", description: "some description")
      vid2 = Video.create(title: "abc", description: "some description")
      expect(Video.search_by_title("#{str}")).to eq([vid1])
    end

    it "returns an array of all matches ordered by created_at" do
      str = "some string"
      vid1 = Video.create(title: "#{str} abc", description: "some description")
      vid2 = Video.create(title: "#{str} def", description: "some description")
      expect(Video.search_by_title("#{str}")).to eq([vid2, vid1])
    end

    it "returns an empty array with a search with an empty string" do
      expect(Video.search_by_title("")).to eq([])
    end
  end
end
