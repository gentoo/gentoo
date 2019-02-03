# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
USE_RUBY="ruby23 ruby24 ruby25"

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

all_ruby_prepare() {
	sed -i -e '/reporters/I s:^:#:' test/gruff_test_case.rb || die
	sed -i -e '2irequire "date"' test/test_scatter.rb || die
}

each_ruby_test() {
	${RUBY} -Ilib:. -e "Dir['test/test_*.rb'].each{|f| require f}" || die
}
