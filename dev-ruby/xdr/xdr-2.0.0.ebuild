# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24"
RUBY_FAKEGEM_RECIPE_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md"

inherit ruby-fakegem

DESCRIPTION="Read/write XDR encoded data structures"
HOMEPAGE="https://github.com/stellar/ruby-xdr"

LICENSE="Apache-2.0"
SLOT="${PV}"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="test"

ruby_add_rdepend ">=dev-ruby/activemodel-4.2.7:*
	>=dev-ruby/activesupport-4.2.7:*"

ruby_add_bdepend "test? ( dev-ruby/bundler
	dev-ruby/rake
	dev-ruby/rspec:3 )"

all_ruby_prepare() {
	sed -i -e '/simplecov/I s:^:#:' spec/spec_helper.rb || die
}

each_ruby_test() {
	RSPEC_VERSION=3 ruby-ng_rspec
	ruby-ng_cucumber
}
