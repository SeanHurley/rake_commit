require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class PromptLineTest < Test::Unit::TestCase

  def test_message_puts_newline_if_saved_attribute_does_not_exist
    File.expects(:exists?).with(Dir.tmpdir + "/pair.data").returns(false)
    RakeCommit::PromptLine.any_instance.expects(:puts).with("\n")
    assert_equal "pair: ", RakeCommit::PromptLine.new("pair").message
  end

  def test_message_puts_last_saved_attribute_if_exists
    File.expects(:exists?).with(Dir.tmpdir + "/pair.data").returns(true)
    File.expects(:read).with(Dir.tmpdir + "/pair.data").returns("Jane Doe\nJohn Doe")
    RakeCommit::PromptLine.any_instance.expects(:puts).with("\nprevious pair: John Doe\n")
    assert_equal "pair: ", RakeCommit::PromptLine.new("pair").message
  end

  def test_save_history_will_save_entered_value_to_disk_with_no_history
    File.expects(:exists?).with(Dir.tmpdir + "/feature.data").returns(false)
    File.expects(:open).with(Dir.tmpdir + "/feature.data", "w").yields(file = mock)
    file.expects(:puts).with(["card 100"])
    RakeCommit::PromptLine.new("feature").save_history("card 100")
  end

  def test_save_history_will_save_entered_value_to_disk_with_existing_history
    File.expects(:exists?).with(Dir.tmpdir + "/feature.data").returns(true)
    File.expects(:read).with(Dir.tmpdir + "/feature.data").returns("card 90")
    File.expects(:open).with(Dir.tmpdir + "/feature.data", "w").yields(file = mock)
    file.expects(:puts).with(["card 90", "card 100"])
    RakeCommit::PromptLine.new("feature").save_history("card 100")
  end

  def test_skips_prompt_if_attribute_is_in_exclusions
    prompt_line = RakeCommit::PromptLine.new("pair", ["pair"])
    assert_equal nil, prompt_line.prompt
  end
end
