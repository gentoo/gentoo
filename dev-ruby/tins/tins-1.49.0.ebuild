# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_RECIPE_TEST="none"

RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="All the stuff that isn't good enough for a real library"
HOMEPAGE="https://github.com/flori/tins"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE="test"

ruby_add_rdepend "
	dev-ruby/bigdecimal
	>=dev-ruby/mize-0.6:0
	dev-ruby/sync
"

ruby_add_bdepend "test? ( >=dev-ruby/test-unit-2.5.1-r1 )"

all_ruby_prepare() {
	sed -e '/simplecov/I s:^:#:' \
		-i tests/test_helper.rb || die
}

each_ruby_test() {
	ruby-ng_testrb-2 -Ilib tests/*_test.rb
}
