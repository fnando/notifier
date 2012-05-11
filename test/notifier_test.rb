require "test_helper"

class NotifierTest < Test::Unit::TestCase
  def setup
    unsupport_all_notifiers
    Notifier.default_notifier = nil
  end

  test "retrieve list of supported notifiers" do
    Notifier::Snarl.expects(:supported?).returns(true)
    Notifier::Knotify.expects(:supported?).returns(true)

    assert_equal 3, Notifier.supported_notifiers.size
  end

  test "return first available notifier" do
    Notifier::Snarl.expects(:supported?).returns(true)
    Notifier::Knotify.expects(:supported?).returns(true)

    assert_equal Notifier::Snarl, Notifier.notifier
  end

  test "prefer default notifier" do
    Notifier::Snarl.stubs(:supported?).returns(true)
    Notifier::Knotify.expects(:supported?).returns(true)

    Notifier.default_notifier = :knotify

    assert_equal Notifier::Knotify, Notifier.notifier
  end

  test "send notification" do
    params = {
      :title => "Some title",
      :message => "Some message",
      :image => "image.png"
    }

    Notifier::Snarl.expects(:supported?).returns(true)
    Notifier::Snarl.expects(:notify).with(params)

    Notifier.notify(params)
  end

  test "retrieve list of all notifiers" do
    assert_equal 8, Notifier.notifiers.size
  end

  test "consider Placebo as fallback notifier" do
    assert_equal Notifier::Placebo, Notifier.supported_notifiers.last
  end

  test "return notifier by its name" do
    assert_equal Notifier::OsdCat, Notifier.from_name(:osd_cat)
    assert_equal Notifier::NotifySend, Notifier.from_name(:notify_send)
    assert_equal Notifier::Growl, Notifier.from_name(:growl)
  end

  test "return notifier by its name when supported" do
    Notifier::Snarl.expects(:supported?).returns(true)

    assert_equal Notifier::Snarl, Notifier.supported_notifier_from_name(:snarl)
  end

  test "return nil when have no supported notifiers" do
    assert_nil Notifier.supported_notifier_from_name(:snarl)
  end

  test "return nil when an invalid notifier name is provided" do
    assert_nil Notifier.from_name(:invalid)
    assert_nil Notifier.supported_notifier_from_name(:invalid)
  end
end
