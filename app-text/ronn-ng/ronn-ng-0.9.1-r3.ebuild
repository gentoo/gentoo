# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_EXTRADOC="AUTHORS CHANGES README.md"
RUBY_FAKEGEM_GEMSPEC="ronn-ng.gemspec"

inherit ruby-fakegem

DESCRIPTION="Builds manuals in HTML and Unix man page format from Markdown"
HOMEPAGE="https://github.com/apjanke/ronn-ng"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 ~riscv sparc x86 ~arm64-macos"

IUSE=""

RDEPEND+="!app-text/ronn"

DEPS="
	>=dev-ruby/kramdown-2.1:2
	>=dev-ruby/nokogiri-1.9.0:0
"

ruby_add_rdepend "
	=dev-ruby/mustache-1*
	${DEPS}
"

ruby_add_bdepend "${DEPS}"

PATCHES=(
	"${FILESDIR}"/${P}-psych-4-tests.patch
)

all_ruby_prepare() {
	sed -i -e '/mustache/ s/0.7/1.0/' ${RUBY_FAKEGEM_GEMSPEC} || die
}

each_ruby_prepare() {
	# Make sure that we always use the right interpreter during tests
	sed -i -e "/output/ s:ronn:${RUBY} bin/ronn:" test/test_ronn.rb || die
	# ... and during the man page build.
	sed -i -e "/sh 'ronn/s:ronn:${RUBY} bin/ronn:" Rakefile || die
}

each_ruby_compile() {
	#if ! [[ -f man/ronn.1 ]] ; then
	#	einfo "Building man pages using ${RUBY}"
	#	PATH="${S}/bin:${PATH}" ${RUBY} -S rake man || die
	#fi
	:;
}

all_ruby_install() {
	all_fakegem_install

	doman man/ronn.1 man/ronn-format.7
}
