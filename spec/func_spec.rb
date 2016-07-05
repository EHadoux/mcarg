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
    n1 = MCArg::LeafNode.new(0.1, "a")
    n2 = MCArg::LeafNode.new(0.3, "b")
    n3 = MCArg::LeafNode.new(0.2, "c")
    n4 = MCArg::LeafNode.new(-1, "d")

    expect(MCArg.max_regret_chance([n1,n2,n3,n4])).to be(n4)
  end

  it "checks the presence of arguments in an execution" do
    goal1 = instance_double("Argument", :label => "a")
    goal2 = instance_double("Argument", :label => "b")
    goal3 = instance_double("Argument", :label => "c")

    expect(MCArg.present([goal1, goal2, goal3], ["a","c"])).to eq({"a"=> 1, "b" => 0, "c" => 1})
  end

  it "refines the belief" do
    distribution = [Rational(1,10), Rational(1,10), Rational(2,10), Rational(6,10)]
    expect(MCArg.refinement(distribution, 1, true, 0).map{ |r| r.to_f }).to eq([0,0,0.3,0.7])
    expect(MCArg.refinement(distribution, 1, false, 0).map{ |r| r.to_f }).to eq([0.3,0.7,0,0])
    expect(MCArg.refinement(distribution, 0.75, true, 0).map{ |r| r.to_f }).to eq([0.025,0.025,0.275,0.675])
    expect(MCArg.refinement(distribution, 1, true, 1).map{ |r| r.to_f }).to eq([0,0.2,0,0.8])
  end

  it "computes dominance" do
    p1 = [1,1,1,1]
    p2 = [1,2,2,2]
    p3 = [1,0,0,0]
    p4 = [1,2,0,2]

    expect(dominate(p1, p2)).to eq(1)
    expect(dominate(p1, p3)).to eq(-1)
    expect(dominate(p1, p4)).to eq(0)
  end

  it "computes Pareto optima" do
    n1 = instance_double("Node", :value => [1,1,1,1])
    n2 = instance_double("Node", :value => [1,2,2,2])
    n3 = instance_double("Node", :value => [1,0,0,0])
    n4 = instance_double("Node", :value => [1,2,0,3])

    expect(MCArg.pareto_dec([n1,n2,n3,n4])).to contain_exactly(n2,n4)
  end

  it "computes Pareto dominated" do
    n1 = instance_double("Node", :value => [1,1,1,1])
    n2 = instance_double("Node", :value => [1,2,2,2])
    n3 = instance_double("Node", :value => [1,0,0,0])
    n4 = instance_double("Node", :value => [1,2,0,3])

    expect(MCArg.dominated_chance([n1,n2,n3,n4])).to contain_exactly(n3)
  end
end
