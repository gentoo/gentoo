# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="History.md README.md"

RUBY_FAKEGEM_GEMSPEC="liquid.gemspec"

inherit ruby-fakegem

DESCRIPTION="Template engine for Ruby"
HOMEPAGE="https://shopify.github.io/liquid/"
SRC_URI="https://github.com/Shopify/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm64"
IUSE="test"

ruby_add_rdepend "
	dev-ruby/bigdecimal
	>=dev-ruby/strscan-3.1.1
"

ruby_add_bdepend "test? ( dev-ruby/minitest )"

all_ruby_prepare() {
	# liquid-c is not packaged
	sed -i -e '/LIQUID_C/ s:^:#:' Rakefile || die

	# Avoid test requiring unpackaged stackprof
	sed -i -e '/assert_no_object_allocations/askip "unpackaged stackprof"' test/integration/context_test.rb || die

	# Avoid test requiring unpackaged lru_redux
	sed -e '/require.*lru_redux/ s:^:#:' \
		-e '/test_expression_cache_with_lru_redux/askip "unpackaged lru_redux"' \
		-i test/integration/expression_test.rb || die

	# Ensure the gem version of strscan is used.
	sed -e '3igem "strscan", ">=3.1.1"' \
		-i test/test_helper.rb || die
}
