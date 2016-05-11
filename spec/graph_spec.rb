require "mcarg"

RSpec.describe MCArg::Graph do
  it "builds all executions" do
    args = ["a", "b", "c", "d"]
    graph = MCArg::Graph.new(args, :no_duplicate)
    executions = graph.build_executions([], [])

    perm = args.permutation.to_a
    perm.each do |p|
      expect(executions).to include(p)
    end
    expect(perm.size).to eq(executions.size)
  end
end
