require "spec_helper"

describe LeanKitKanban::Card do
  describe :find do
    before :each do
      @board_id  = double("boardID")
      @card_id   = double("cardID")
    end

    it "should get the card from the given board" do
      api_call = "/Board/#{@board_id}/GetCard/#{@card_id}"
      LeanKitKanban::Card.should_receive(:get).with(api_call)
      LeanKitKanban::Card.find(@board_id, @card_id)
    end
  end

  describe :find_by_external_id do
    before :each do
      @board_id    = double("boardID")
      @external_id = double("externalID")
    end

    it "should get the card from the given board, by external id" do
      api_call = "/Board/#{@board_id}/GetCardByExternalId/#{@external_id}"
      LeanKitKanban::Card.should_receive(:get).with(api_call)
      LeanKitKanban::Card.find_by_external_id(@board_id, @external_id)
    end
  end

  describe :delete_multiple do
    before :each do
      @board_id = double("boardID")
      @card_ids = [ double("cardID_0"), double("cardID_1"), double("cardID_2") ]
    end

    it "should delete the cards from the given board" do
      api_call = "/Board/#{@board_id}/DeleteCards"
      LeanKitKanban::Card.should_receive(:post).with(api_call, @card_ids)
      LeanKitKanban::Card.delete_multiple(@board_id, @card_ids)
    end
  end

  describe :delete do
    before :each do
      @board_id  = double("boardID")
      @card_id   = double("cardID")
    end

    it "should delete the card from the given board" do
      api_call = "/Board/#{@board_id}/DeleteCard/#{@card_id}"
      LeanKitKanban::Card.should_receive(:post).with(api_call, {})
      LeanKitKanban::Card.delete(@board_id, @card_id)
    end
  end

  describe :add do
    before :each do
      @board_id  = double("boardID")
      @lane_id   = double("laneID")
      @position  = double("position")
      @body = { "Title" => double("title"), "TypeId" => double("typeID")}
    end

    it "should add the card into the lane and position provided" do
      api_call = "/Board/#{@board_id}/AddCard/Lane/#{@lane_id}/Position/#{@position}"
      LeanKitKanban::Card.should_receive(:post).with(api_call, @body)
      LeanKitKanban::Card.add(@board_id, @lane_id, @position, @body)
    end
  end

  describe :update do
    before :each do
      @board_id = double("boardID")
      @body = { "Id" => double("Id"), "Title" => double("title"), "Description" => double("description") }
    end

    it "should update the card using the title and description provided" do
      api_call = "/Board/#{@board_id}/UpdateCard/"
      LeanKitKanban::Card.should_receive(:post).with(api_call, @body)
      LeanKitKanban::Card.update(@board_id, @body)
    end
  end

  describe :add_multiple do
    before :each do
      @cards = []
      @board_id  = double("boardID")
      @wip_comment = "this is a comment"

      lane_ids = [ double("lane_0"), double("lane_1") ]
      titles = [ double("title_0"), double("title_1") ]
      type_ids = [ double("type_0"), double("type_1") ]

      lane_ids.each_with_index { |item, i|
        @cards[i] = { "LaneId" => lane_ids[i], "Title" => titles[i], "TypeId" => type_ids[i] }
      }
    end

    it "should add the cards into the lanes and positions provided" do
      api_call = "/Board/#{@board_id}/AddCards?wipOverrideComment=" + URI::encode(@wip_comment)
      LeanKitKanban::Card.should_receive(:post).with(api_call, @cards)
      LeanKitKanban::Card.add_multiple(@board_id, @wip_comment, @cards)
    end
  end

  describe :history do
    it "should get the history of cards from the board that is provided" do
      api_call = "/Card/History/#{@board_id}/#{@card_id}"
      LeanKitKanban::Card.should_receive(:get).with(api_call)
      LeanKitKanban::Card.history(@board_id, @card_id)
    end
  end

  describe :move do
    it "should move the card into the lane and position that are provided" do
      @lane_id = 12
      @position = 0
      api_call = "/Board/#{@board_id}/MoveCard/#{@card_id}/Lane/#{@lane_id}/Position/0"
      LeanKitKanban::Card.should_receive(:post).with(api_call,{})
      LeanKitKanban::Card.move(@board_id, @card_id, @lane_id, @position)
    end
  end
end
