# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
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

all_ruby_prepare() {
	sed -i -e '/bundler/,/pry/ s:^:#:' spec/spec_helper.rb || die
}
