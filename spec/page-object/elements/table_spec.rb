require 'spec_helper'
require 'page-object/elements'

describe PageObject::Elements::Table do
  describe "when mapping how to find an element" do
    it "should map watir types to same" do
      [:class, :id, :index, :xpath].each do |t|
        identifier = PageObject::Elements::Table.watir_identifier_for t => 'value'
        expect(identifier.keys.first).to eql t
      end
    end

    it "should map selenium types to same" do
      [:class, :id, :index, :name, :xpath].each do |t|
        key, value = PageObject::Elements::Table.selenium_identifier_for t => 'value'
        expect(key).to eql t
      end
    end
  end

  describe "interface" do
    let(:table_element) { double('table_element') }

    before(:each) do
      table_element.stub(:[]).and_return(table_element)
      table_element.stub(:find_elements).and_return(table_element)
    end

    it "should register with tag_name :table" do
      expect(::PageObject::Elements.element_class_for(:table)).to eql ::PageObject::Elements::Table
    end

    context "for watir" do
      let(:watir_table) { PageObject::Elements::Table.new(table_element, :platform => :watir_webdriver) }
      
      it "should return a table row when indexed" do
        table_element.stub(:[]).with(1).and_return(table_element)
        expect(watir_table[1]).to be_instance_of PageObject::Elements::TableRow
      end

      it "should return the first row" do
        table_element.stub(:[]).with(0).and_return(table_element)
        expect(watir_table.first_row).to be_instance_of PageObject::Elements::TableRow
      end

      it "shoudl return the last row" do
        table_element.stub(:[]).with(-1).and_return(table_element)
        expect(watir_table.last_row).to be_instance_of PageObject::Elements::TableRow
      end

      it "should return the number of rows" do
        table_element.stub(:wd).and_return(table_element)
        table_element.should_receive(:find_elements).with(:xpath, ".//child::tr").and_return(table_element)
        table_element.should_receive(:size).and_return(2)
        expect(watir_table.rows).to eql 2
      end

      it "should iterate over the table rows" do
        watir_table.should_receive(:rows).and_return(2)
        count = 0
        watir_table.each { |e| count += 1 }
        expect(count).to eql 2
      end
    end

    context "for selenium" do
      let(:selenium_table) { PageObject::Elements::Table.new(table_element, :platform => :selenium_webdriver) }
      
      it "should return a table row when indexed" do
        table_element.should_receive(:find_elements).with(:xpath, ".//child::tr").and_return(table_element)
        expect(selenium_table[1]).to be_instance_of PageObject::Elements::TableRow
      end

      it "should return the first row" do
        table_element.stub(:[]).with(0).and_return(table_element)
        expect(selenium_table.first_row).to be_instance_of PageObject::Elements::TableRow
      end

      it "shoudl return the last row" do
        table_element.stub(:[]).with(-1).and_return(table_element)
        expect(selenium_table.last_row).to be_instance_of PageObject::Elements::TableRow
      end

      it "should return the number of rows" do
        table_element.should_receive(:find_elements).with(:xpath, ".//child::tr").and_return(table_element)
        table_element.should_receive(:size).and_return(2)
        expect(selenium_table.rows).to eql 2
      end

      it "should iterate over the table rows" do
        selenium_table.should_receive(:rows).and_return(2)
        count = 0
        selenium_table.each { |e| count += 1 }
        expect(count).to eql 2
      end
    end
  end
end
