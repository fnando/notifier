require "spec_helper"

describe Notifier do
  before do
    unsupport_all_notifiers
    Notifier.default_notifier = nil
  end

  it "retrieves list of supported notifiers" do
    Notifier::Snarl.stub :supported? => true
    Notifier::Knotify.stub :supported? => true

    expect(Notifier.supported_notifiers.size).to eql(3)
  end

  it "returns first available notifier" do
    Notifier::Snarl.stub :supported? => true
    Notifier::Knotify.stub :supported? => true

    expect(Notifier.notifier).to eql(Notifier::Snarl)
  end

  it "prefers default notifier" do
    Notifier::Snarl.stub :supported? => true
    Notifier::Knotify.stub :supported? => true

    Notifier.default_notifier = :knotify

    expect(Notifier.notifier).to eql(Notifier::Knotify)
  end

  it "sends notification" do
    params = {
      :title => "Some title",
      :message => "Some message",
      :image => "image.png"
    }

    Notifier::Snarl.stub :supported? => true
    Notifier::Snarl.should_receive(:notify).with(params)

    Notifier.notify(params)
  end

  it "retrieves list of all notifiers" do
    expect(Notifier.notifiers.size).to eql(9)
  end

  it "considers Placebo as fallback notifier" do
    expect(Notifier.supported_notifiers.last).to eql(Notifier::Placebo)
  end

  it "returns notifier by its name" do
    expect(Notifier.from_name(:osd_cat)).to eql(Notifier::OsdCat)
    expect(Notifier.from_name(:notify_send)).to eql(Notifier::NotifySend)
    expect(Notifier.from_name(:growl)).to eql(Notifier::Growl)
  end

  it "returns notifier by its name when supported" do
    Notifier::Snarl.stub :supported? => true
    expect(Notifier.supported_notifier_from_name(:snarl)).to eql(Notifier::Snarl)
  end

  it "returns nil when have no supported notifiers" do
    expect(Notifier.supported_notifier_from_name(:snarl)).to be_nil
  end

  it "returns nil when an invalid notifier name is provided" do
    expect(Notifier.from_name(:invalid)).to be_nil
    expect(Notifier.supported_notifier_from_name(:invalid)).to be_nil
  end
end
