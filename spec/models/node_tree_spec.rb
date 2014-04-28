# coding: utf-8

require 'spec_helper'

describe Contentr::Page do

  before(:each) do

    site = create(:site)
    node1 = create(:contentpage, name: 'Node1', slug: 'Node1', parent: site)
    node2 = create(:contentpage, name: 'Node2', slug: 'Node2', parent: site)
    node3 = create(:contentpage, name: 'Node3', slug: 'Node3', parent: site)

    node11 = create(:contentpage, name: 'Node11', slug: 'Node11', parent: node1)
    node12 = create(:contentpage, name: 'Node12', slug: 'Node12', parent: node1)
    node21 = create(:contentpage, name: 'Node21', slug: 'Node21', parent: node2)
    node22 = create(:contentpage, name: 'Node22', slug: 'Node22', parent: node2)
    node31 = create(:contentpage, name: 'Node31', slug: 'Node31', parent: node3)

    node211 = create(:contentpage, name: 'Node211', slug: 'Node211', parent: node21)
    node212 = create(:contentpage, name: 'Node212', slug: 'Node212', parent: node21)
    node221 = create(:contentpage, name: 'Node221', slug: 'Node221', parent: node22)
  end

  it 'root nodes' do
    root_nodes = Contentr::Page.roots()
    root_nodes.should_not be_nil
    expect(root_nodes.count).to be 1
    root_nodes.first.children[0].name.should eql "Node1"
    root_nodes.first.children[1].name.should eql "Node2"
    root_nodes.first.children[2].name.should eql "Node3"
  end

  it 'parent and children relation' do
    node = Contentr::Page.where(name: "Node21").first
    node.should_not be_nil

    # children
    node.children.should_not be_empty
    node.children[0].name.should eql "Node211"
    node.children[1].name.should eql "Node212"

    # parent
    node.children[0].parent.name.should eql "Node21"
    node.children[1].parent.name.should eql "Node21"
    node.parent.name.should eql "Node2"
  end

  it "parent ids" do
    node = Contentr::Page.where(name: "Node212").first
    node.should_not be_nil
    [node.parent.parent.parent.id, node.parent.parent.id, node.parent.id].should eql node.ancestor_ids
  end

  it "change parent" do
    node211 = Contentr::Page.where(name: "Node211").first
    node21  = Contentr::Page.where(name: "Node21").first
    node2   = Contentr::Page.where(name: "Node2").first
    node3   = Contentr::Page.where(name: "Node3").first

    node21.should eql node211.parent
    node2.should eql node21.parent
    [node2.parent.id, node2.id, node21.id].should eql node211.ancestor_ids
    '/node2/node21/node211'.should eql node211.url_path

    # move node21 to it's new parent node3
    node21.parent = node3
    node21.save!
    node211.reload

    [node3.parent.id, node3.id, node21.id].should eql node211.ancestor_ids
    '/node3/node21/node211'.should eql node211.url_path
  end
end
