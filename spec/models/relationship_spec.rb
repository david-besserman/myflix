require 'spec_helper'

describe Relationship do
  it { should belong_to(:follower) }
  it { should belong_to(:leader) }
  it { should validate_presence_of(:follower) }
  it { should validate_presence_of(:leader) }
end

