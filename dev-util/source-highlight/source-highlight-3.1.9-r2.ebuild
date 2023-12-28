# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 flag-o-matic libtool optfeature

DESCRIPTION="Generate highlighted source code as an (x)html document"
HOMEPAGE="https://www.gnu.org/software/src-highlite/source-highlight.html"
SRC_URI="mirror://gnu/src-highlite/${P}.tar.gz"

LICENSE="GPL-3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
SLOT="0"
IUSE="doc static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/boost:="
DEPEND="${RDEPEND}"
BDEPEND="test? ( dev-util/ctags )"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1.9-test-clang-p1.patch
	"${FILESDIR}"/${PN}-3.1.9-test-clang-p2.patch
)

src_prepare() {
	default

	# Although all unpatched libtools are probably broken, this one ignores LTO
	# warning flags.
	elibtoolize
}

src_configure() {
	# required as rev-dep of dev-libs/boost-1.62.0
	# https://wiki.gentoo.org/wiki/Project:C%2B%2B/Maintaining_ABI
	append-cxxflags -std=c++14
	# ODR violations: https://savannah.gnu.org/bugs/index.php?65086
	filter-lto

	econf \
		--with-boost="${EPREFIX}/usr" \
		--with-boost-regex="boost_regex" \
		--without-bash-completion \
		$(use_enable static-libs static)
}

src_test() {
	export LD_LIBRARY_PATH="${S}/lib/srchilite/.libs/"
	# upstream uses the same temporary filenames in numerous places
	# see https://bugs.gentoo.org/635100
	emake -j1 check
}

src_install() {
	use doc && local HTML_DOCS=( doc/*.{html,css,java} )
	default

	# That's not how we want it
	rm -rf "${ED}"/usr/share/{aclocal,doc} || die

	# package provides .pc file
	find "${D}" -name '*.la' -delete || die

	dobashcomp completion/source-highlight
}

pkg_postinst() {
	optfeature "ctags support" dev-util/ctags
}
