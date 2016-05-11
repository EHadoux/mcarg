require "mcarg"

RSpec.describe MCArg do
  it "maximizes in decision nodes" do
    n1 = instance_double("Node", :value => 0.1)
    n2 = instance_double("Node", :value => 0.3)
    n3 = instance_double("Node", :value => 0.2)
    n4 = instance_double("Node", :value => -1)

    expect(MCArg.max_dec([n1,n2,n3,n4])).to be(n2)
  end

  it "minimizes in decision nodes" do
    n1 = instance_double("Node", :value => 0.1)
    n2 = instance_double("Node", :value => 0.3)
    n3 = instance_double("Node", :value => 0.2)
    n4 = instance_double("Node", :value => -1)

    expect(MCArg.min_dec([n1,n2,n3,n4])).to be(n4)
  end

  it "maximizes in chance nodes" do
    n1 = instance_double("Node", :value => 0.1)
    n2 = instance_double("Node", :value => 0.3)
    n3 = instance_double("Node", :value => 0.2)
    n4 = instance_double("Node", :value => -1)

    expect(MCArg.max_dec([n1,n2,n3,n4])).to be(n2)
  end

  it "minimizes in chance nodes" do
    n1 = instance_double("Node", :value => 0.1)
    n2 = instance_double("Node", :value => 0.3)
    n3 = instance_double("Node", :value => 0.2)
    n4 = instance_double("Node", :value => -1)

    expect(MCArg.min_chance([n1,n2,n3,n4])).to be(n4)
  end

  it "maximizes the regret in chance nodes" do
    n1 = instance_double("Node", :value => 0.1)
    n2 = instance_double("Node", :value => 0.3)
    n3 = instance_double("Node", :value => 0.2)
    n4 = instance_double("Node", :value => -1)

    expect(MCArg.max_regret_chance([n1,n2,n3,n4])).to be(n4)
  end
end
