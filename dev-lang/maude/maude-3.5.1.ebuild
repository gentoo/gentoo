# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit autotools

MY_PN=${PN^}
MY_P=${MY_PN}${PV}
GIO_DL="https://github.com/maude-lang/maude-lang.github.io/releases/download/maude"
MANUAL=${MY_P}-manual.pdf

DESCRIPTION="High-level specification language for equational and logic programming"
HOMEPAGE="https://maude.cs.uiuc.edu/"
SRC_URI="https://github.com/maude-lang/Maude/archive/refs/tags/${MY_P}.tar.gz
	doc? ( ${GIO_DL}/${MANUAL} )
	examples? ( ${GIO_DL}/${P^}-manual-book-examples.zip )"

S="${WORKDIR}"/${MY_PN}-${MY_P}

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
	"${FILESDIR}/${PN}-3.4-search-datadir.patch"
	"${FILESDIR}/${PN}-2.7-AR.patch"
	"${FILESDIR}/${PN}-3.2.2-prll.patch"
	"${FILESDIR}/${PN}-3.2.2-fileTest.patch" # Drop a test
)

src_prepare() {
	if use examples; then
		pushd .. >/dev/null || die
		mkdir examples || die
		mv *maude examples/ || die
		mv *.txt maude.sty only-book README.md string_extract.py \
			examples/ || die
		popd >/dev/null || die
	fi
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

	# install docs and examples
	use doc && dodoc "${DISTDIR}"/${MANUAL}
	if use examples; then
		dodoc -r "${WORKDIR}"/examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
