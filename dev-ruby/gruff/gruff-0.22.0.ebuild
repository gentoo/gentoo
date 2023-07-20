# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_EXTRAINSTALL="assets rails_generators"

RUBY_FAKEGEM_GEMSPEC="gruff.gemspec"

inherit ruby-fakegem

DESCRIPTION="Beautiful graphs for one or multiple datasets"
HOMEPAGE="https://github.com/topfunky/gruff"
SRC_URI="https://github.com/topfunky/gruff/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

# imagemagick is an indirect dependency through rmagick. However, for
# gruff to work properly imagemagick needs to be compiled with truetype
# support and this cannot be expressed in the rmagick dependency. Tests
# also require imagemagick to have jpeg and png support.
DEPEND="${DEPEND} test? ( media-gfx/imagemagick[jpeg,png,truetype,webp] )"
RDEPEND="${RDEPEND} media-gfx/imagemagick[truetype]"

ruby_add_rdepend "dev-ruby/histogram >=dev-ruby/rmagick-4.2:*"
ruby_add_bdepend "
	test? (
		dev-ruby/test-unit
	)"

all_ruby_prepare() {
	sed -i -e '/\(reporters\|simplecov\)/I s:^:#:' test/gruff_test_case.rb || die
	sed -i -e '2irequire "date"' test/test_scatter.rb || die

	sed -e 's/git ls-files/find * -print/' \
		-i ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_test() {
	# Skip the image comparison checks since the images are not
	# pixel-perfect identical, most likely due to the use of a slightly
	# different font.
	SKIP_CHECK=true ${RUBY} -Ilib:. -e "Dir['test/test_*.rb'].each{|f| require f}" || die
}
