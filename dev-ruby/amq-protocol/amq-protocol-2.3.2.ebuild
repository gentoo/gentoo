# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_EXTRADOC="ChangeLog.md README.md"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="An AMQP 0.9.1 serialization library for Ruby"
HOMEPAGE="https://github.com/ruby-amqp/amq-protocol"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/bundler dev-ruby/rspec-its )"

all_ruby_prepare() {
	sed -i -e '/\(simplecov\|effin_utf8\|byebug\)/ s:^:#:' Gemfile || die
	sed -i -e '/effin_utf8/ s:^:#:' spec/spec_helper.rb || die
}
