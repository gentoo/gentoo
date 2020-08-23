# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby24 ruby25 ruby26 ruby27"

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

ruby_add_rdepend ">=dev-ruby/activemodel-5.2.0:*
	>=dev-ruby/activesupport-5.2.0:*"

all_ruby_prepare() {
	sed -i -e '/bundler/,/pry/ s:^:#:' spec/spec_helper.rb || die
}
