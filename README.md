# Notifier

[![Gem](https://img.shields.io/gem/v/notifier.svg)](https://rubygems.org/gems/notifier)
[![Gem](https://img.shields.io/gem/dt/notifier.svg)](https://rubygems.org/gems/notifier)

Send system notifications on several platforms with a simple and unified API.
Currently supports:

- terminal-notifier (Notification Center wrapper for Mac OS X)
- [HUD](https://fnando.gumroad.com/l/hud-macos)
- Kdialog (Linux/KDE)
- Knotify (Linux/KDE)
- OSD Cat (Linux)
- Libnotify (Linux)
- Snarl (Windows)

## Installation

    gem install notifier

### Mac OS X

#### terminal-notifier

- Install terminal-notifier - https://github.com/alloy/terminal-notifier

terminal-notifier also supports two additional flags:

- `subtitle`
- `sound`

See terminal-notifier's help for additional information.

#### hud

- Install HUD - https://fnando.gumroad.com/l/hud-macos

### Linux

If you're a linux guy, you can choose one of these methods:

- Install libnotify-bin and its dependencies:
  `sudo aptitude install libnotify-bin`
- Install xosd-bin: `sudo aptitude install xosd-bin`
- KDE users don't need to install anything: Test Notifier will use +knotify+ or
  +kdialog+.

### Windows

- Install Snarl: download from http://www.fullphat.net
- Install ruby-snarl: `gem install ruby-snarl`

## Usage

Notifier will try to detect which notifiers are available in your system. So you
can just send a message:

```ruby
Notifier.notify(
  image: "image.png",
  title: "Testing Notifier",
  message: "Sending an important message!"
)
```

Not all notifiers support the image option, therefore it will be ignored.

If your system support more than one notifier, you can specify which one you
prefer:

```ruby
Notifier.default_notifier = :notify_send
```

Alternatively, you can set the default notifier by using the `NOTIFIER` env var.
The following example assumes `test_notifier` is configured on this Rails
project. The env var has precedence of `Notifier.default_notifier`.

```console
$ NOTIFIER=hud rails test
```

The available names are `terminal_notifier`, `kdialog`, `knotify`,
`notify_send`, `osd_cat`, and `snarl`.

There are several helper methods that you can use in order to retrieve
notifiers.

- `Notifier.notifier`: return the first supported notifier
- `Notifier.notifiers`: return all notifiers
- `Notifier.supported_notifiers`: return only supported notifiers
- `Notifier.from_name(name)`: find notifier by its name
- `Notifier.supported_notifier_from_name(name)`: find a supported notifier by
  its name

## Creating custom notifiers

To create a new notifier, just create a module on `Notifier` namespace that
implements the following interface:

```ruby
module Notifier
  module MyCustomNotifier
    def self.supported?
    end

    def self.notify(options)
    end
  end
end
```

## Maintainer

- Nando Vieira - https://nandovieira.com

## Contributors

https://github.com/fnando/notifier/graphs/contributors

## License

(The MIT License)

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the 'Software'), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
