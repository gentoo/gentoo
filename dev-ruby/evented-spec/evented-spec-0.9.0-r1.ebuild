# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.textile"

inherit ruby-fakegem

DESCRIPTION="A set of helpers to help you test your asynchronous code"
HOMEPAGE="https://github.com/ruby-amqp/evented-spec"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

# Tests require a running AMQP server and AMQP installed. Since
# currently AMQP is the only package using evented-spec we just skip the
# tests here altogether to avoid circular dependencies.
RESTRICT="test"

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/ s:^:#:' -e '/effin_utf8/ s:^:#:' spec/spec_helper.rb || die
}
