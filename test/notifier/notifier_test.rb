require "test_helper"

class NotifierTest < Minitest::Test
  setup do
    Notifier.notifiers.each do |notifier|
      notifier.stubs(:supported?).returns(false) unless notifier == Notifier::Placebo
    end

    Notifier.default_notifier = nil
  end

  test "retrieves list of supported notifiers" do
    Notifier::Snarl.stubs(:supported?).returns(true)
    Notifier::Knotify.stubs(:supported?).returns(true)

    assert_equal 3, Notifier.supported_notifiers.size
  end

  test "returns first available notifier" do
    Notifier::Snarl.stubs(:supported?).returns(true)
    Notifier::Knotify.stubs(:supported?).returns(true)

    assert_equal Notifier::Snarl, Notifier.notifier
  end

  test "prefers default notifier" do
    Notifier::Snarl.stubs(:supported?).returns(true)
    Notifier::Knotify.stubs(:supported?).returns(true)

    Notifier.default_notifier = :knotify

    assert_equal Notifier::Knotify, Notifier.notifier
  end

  test "sends notification" do
    params = {
      title: "Some title",
      message: "Some message",
      image: "image.png"
    }

    Notifier::Snarl.stubs(:supported?).returns(true)
    Notifier::Snarl.expects(:notify).with(params)

    Notifier.notify(params)
  end

  test "retrieves list of all notifiers" do
    assert_equal 9, Notifier.notifiers.size
  end

  test "considers Placebo as fallback notifier" do
    assert_equal Notifier::Placebo, Notifier.supported_notifiers.last
  end

  test "returns notifier by its name" do
    assert_equal Notifier::OsdCat, Notifier.from_name(:osd_cat)
    assert_equal Notifier::NotifySend, Notifier.from_name(:notify_send)
    assert_equal Notifier::Growl, Notifier.from_name(:growl)
  end

  test "returns notifier by its name when supported" do
    Notifier::Snarl.expects(:supported?).returns(true)
    assert_equal Notifier::Snarl, Notifier.supported_notifier_from_name(:snarl)
  end

  test "returns nil when have no supported notifiers" do
    assert_nil Notifier.supported_notifier_from_name(:snarl)
  end

  test "returns nil when an invalid notifier name is provided" do
    assert_nil Notifier.from_name(:invalid)
    assert_nil Notifier.supported_notifier_from_name(:invalid)
  end
end
