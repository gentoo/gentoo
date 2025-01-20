# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="History.md README.md"
RUBY_FAKEGEM_GEMSPEC="liquid.gemspec"

inherit ruby-fakegem

DESCRIPTION="Template engine for Ruby"
HOMEPAGE="https://shopify.github.io/liquid/"
SRC_URI="https://github.com/Shopify/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="4"
KEYWORDS="~amd64 ~arm64"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/minitest
	dev-ruby/spy )"

all_ruby_prepare() {
	# liquid-c is not packaged
	sed -i -e '/LIQUID-C/ s:^:#:' Rakefile || die

	# Avoid test requiring unpackaged stackprof
	sed -i -e '/assert_no_object_allocations/askip "unpackaged stackprof"' test/unit/context_unit_test.rb || die

	# Avoid tests using taint since this is no longer supported in ruby 2.7+
	sed -i -e '/test.*tainted_attr/askip "taint is no longer supported"' test/integration/drop_test.rb || die
}
