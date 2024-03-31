# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="History.md README.md"

RUBY_FAKEGEM_GEMSPEC="liquid.gemspec"

inherit ruby-fakegem

SRC_URI="https://github.com/Shopify/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
DESCRIPTION="Template engine for Ruby"
HOMEPAGE="https://shopify.github.io/liquid/"

LICENSE="MIT"
SLOT="$(ver_cut 1)"
KEYWORDS="~amd64 ~arm64"
IUSE="test"

ruby_add_bdepend "test? ( dev-ruby/minitest )"

all_ruby_prepare() {
	# liquid-c is not packaged
	sed -i -e '/LIQUID_C/ s:^:#:' Rakefile || die

	# Avoid test requiring unpackaged stackprof
	sed -i -e '/assert_no_object_allocations/askip "unpackaged stackprof"' test/integration/context_test.rb || die
}
