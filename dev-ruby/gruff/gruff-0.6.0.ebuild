# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22"

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="History.txt Manifest.txt README.md RELEASE.md"

RUBY_FAKEGEM_EXTRAINSTALL="assets rails_generators"

inherit ruby-fakegem

DESCRIPTION="Beautiful graphs for one or multiple datasets"
HOMEPAGE="https://github.com/topfunky/gruff"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-macos"
IUSE=""

RUBY_PATCHES=(
	${PN}-0.3.6-spider.patch
)

# imagemagick is an indirect dependency through rmagick. However, for
# gruff to work properly imagemagick needs to be compiled with truetype
# support and this cannot be expressed in the rmagick dependency. Tests
# also require imagemagick to have jpeg and png support.
DEPEND="${DEPEND} test? ( media-gfx/imagemagick[jpeg,png,truetype,webp] )"
RDEPEND="${RDEPEND} media-gfx/imagemagick[truetype]"

ruby_add_rdepend ">=dev-ruby/rmagick-2.13.4"
ruby_add_bdepend "
	test? (
		dev-ruby/hoe
		dev-ruby/test-unit
	)"

each_ruby_test() {
	ruby-ng_testrb-2 test/test_*.rb
}
