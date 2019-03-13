# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="History.md README.md"

inherit ruby-fakegem

SRC_URI="https://github.com/Shopify/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="Template engine for Ruby"
HOMEPAGE="https://shopify.github.io/liquid/"

LICENSE="MIT"
SLOT="4"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/minitest
	dev-ruby/spy )"

all_ruby_prepare() {
	# liquid-c is not packaged
	sed -i -e '/LIQUID-C/ s:^:#:' Rakefile || die

	# Avoid test requiring unpackaged stackprof
	sed -i -e '/assert_no_object_allocations/askip "unpackaged stackprof"' test/unit/context_unit_test.rb
}
