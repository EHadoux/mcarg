RSpec.describe MCArg::Graph do
  it "constructs the graph from a file" do
    graph = MCArg::Graph.build_from_apx("spec/resources/3_args.apx")

    expect(graph.args.size).to eq(3)
    expect(graph.args["foo"].attacked.size).to eq(2)
    expect(graph.args["bar"].attacked.size).to eq(1)
    expect(graph.args["baz"].attacked.size).to eq(0)
    expect(graph.args["foo"].attackers.size).to eq(0)
    expect(graph.args["bar"].attackers.size).to eq(1)
    expect(graph.args["baz"].attackers.size).to eq(2)
    expect(graph.args["foo"].initial_belief).to eq(1)
    expect(graph.args["bar"].initial_belief).to eq(1)
    expect(graph.args["baz"].initial_belief).to eq(0.116)
  end

  it "builds all executions" do
    args = {"a" => nil, "b" => nil, "c" => nil, "d" => nil}
    graph = MCArg::Graph.new(args, [])
    executions = graph.build_executions([], [], [:no_duplicate])

    perm = args.keys.permutation.to_a
    perm.each do |p|
      expect(executions).to include(p)
    end
    expect(perm.size).to eq(executions.size)
  end
end
