# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_EXTRADOC="ChangeLog.md README.md"
RUBY_FAKEGEM_GEMSPEC="amq-protocol.gemspec"
RUBY_FAKEGEM_RECIPE_TEST="rspec3"

inherit ruby-fakegem

DESCRIPTION="An AMQP 0.9.1 serialization library for Ruby"
HOMEPAGE="https://github.com/ruby-amqp/amq-protocol"
SRC_URI="https://github.com/ruby-amqp/amq-protocol/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/bundler dev-ruby/rspec-its )"

all_ruby_prepare() {
	sed -i -e '/\(gem.*benchmark\|simplecov\|effin_utf8\|byebug\)/ s:^:#:' Gemfile || die
	sed -i -e '/effin_utf8/ s:^:#:' spec/spec_helper.rb || die

	# Avoid spec where host is either nil or "" depending on ruby version
	sed -i -e '/falls back to default nil host/ s/it/xit/' spec/amq/uri_parsing_spec.rb || die
}
