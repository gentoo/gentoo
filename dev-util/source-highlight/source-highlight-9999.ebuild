# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 flag-o-matic libtool optfeature autotools

DESCRIPTION="Generate highlighted source code as an (x)html document"
HOMEPAGE="https://www.gnu.org/software/src-highlite/source-highlight.html"

LICENSE="GPL-3"
SLOT="0"
if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://https.git.savannah.gnu.org/git/src-highlite.git"
else
	SRC_URI="mirror://gnu/src-highlite/${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-solaris"
fi

IUSE="doc static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="dev-libs/boost:="
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
	test? ( dev-util/ctags )
"

src_prepare() {
	default

	[[ ${PV} == 9999 ]] && eautoreconf

	if ! use doc; then
		sed -i -e 's/ doc / /g' Makefile* || die
	fi

	# Although all unpatched libtools are probably broken, this one ignores LTO
	# warning flags.
	elibtoolize
}

src_configure() {
	# Needs bison
	unset YACC LEX

	# Fails to build otherwise with some ambiguous refs
	append-cxxflags -std=gnu++17

	# ODR violations: https://savannah.gnu.org/bugs/index.php?65086
	filter-lto

	econf \
		--without-bash-completion \
		$(use_enable static-libs static) \
		--with-boost="${EPREFIX}/usr" \
		--with-boost-regex="boost_regex"
}

src_compile() {
	local -x LD_LIBRARY_PATH="${S}/lib/srchilite/.libs/"
	emake
}

src_test() {
	local -x LD_LIBRARY_PATH="${S}/lib/srchilite/.libs/"
	emake check
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
