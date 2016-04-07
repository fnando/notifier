require "test_helper"

class SnarlTest < Minitest::Test
  test "sends notification" do
    Snarl.expects(:show_message).with("TITLE", "MESSAGE", "IMAGE")

    Notifier::Snarl.notify(title: "TITLE", message: "MESSAGE", image: "IMAGE")
  end
end
