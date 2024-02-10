# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="History.md README.md"
RUBY_FAKEGEM_GEMSPEC="liquid.gemspec"

inherit ruby-fakegem

SRC_URI="https://github.com/Shopify/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="Template engine for Ruby"
HOMEPAGE="https://shopify.github.io/liquid/"

LICENSE="MIT"
SLOT="4"
KEYWORDS="~amd64 ~arm64"
IUSE=""

PATCHES=( "${FILESDIR}/${P}-ruby30.patch" )

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
