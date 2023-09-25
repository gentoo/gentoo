# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"
RUBY_FAKEGEM_GEMSPEC="rgl.gemspec"

inherit ruby-fakegem

DESCRIPTION="RGL is a framework for graph data structures and algorithms"
HOMEPAGE="https://github.com/monora/rgl"
SRC_URI="https://github.com/monora/rgl/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE=""

DEPEND+=" test? ( media-gfx/graphviz )"

ruby_add_rdepend "
	dev-ruby/pairing_heap:0
	>=dev-ruby/rexml-3.2.4:3
	>=dev-ruby/stream-0.5.3 =dev-ruby/stream-0.5*
"

ruby_add_bdepend "dev-ruby/yard test? ( dev-ruby/test-unit )"

all_ruby_prepare() {
	sed -i -e '/bundler/I s:^:#:' Rakefile || die
	sed -i -e '/simplecov/I s:^:#:' test/test_helper.rb || die
}
