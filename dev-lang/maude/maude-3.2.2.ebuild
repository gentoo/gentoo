# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit autotools

MY_P="${P^}"
GIO_DL="https://github.com/maude-lang/maude-lang.github.io/releases/download/maude"

DESCRIPTION="High-level specification language for equational and logic programming"
HOMEPAGE="https://maude.cs.uiuc.edu/"
SRC_URI="https://github.com/maude-lang/Maude/archive/refs/tags/${PV}.tar.gz -> ${MY_P}.tar.gz
	https://maude.cs.illinois.edu/w/images/0/0a/Full-Maude-3.1.zip
	doc? ( ${GIO_DL}/Maude-3.2.1-manual.pdf )
	examples? ( ${GIO_DL}/Maude-3.1-manual-book-examples.zip )"

S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc examples"

QA_CONFIG_IMPL_DECL_SKIP=(
	ppoll # Uses alternative poll
)

RDEPEND="
	dev-libs/gmp:=[cxx(+)]
	dev-libs/libtecla
	sci-libs/buddy"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip
	app-alternatives/yacc
	app-alternatives/lex"

PATCHES=(
	"${FILESDIR}/${PN}-2.6-search-datadir.patch"
	"${FILESDIR}/${PN}-2.7-AR.patch"
	"${FILESDIR}/${PN}-3.2.2-prll.patch"
	"${FILESDIR}/${PN}-3.1-curses.patch"
	"${FILESDIR}/${PN}-3.2.2-fileTest.patch" # Drop a test
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=(
		--datadir="${EPREFIX}/usr/share/${PN}"
		--without-yices2
		# Breaks glibc-2.34 support
		--without-libsigsegv
	)
	econf "${myconf[@]}"
}

src_install() {
	default

	# install full maude
	insinto /usr/share/${PN}
	newins "${WORKDIR}"/full-maude31.maude full-maude.maude

	# install docs and examples
	use doc && dodoc "${DISTDIR}"/Maude-3.2.1-manual.pdf
	if use examples; then
		dodoc -r "${WORKDIR}"/examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
