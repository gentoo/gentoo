# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_P="${P^}"

DESCRIPTION="High-level specification language for equational and logic programming"
HOMEPAGE="https://maude.cs.uiuc.edu/"
SRC_URI="
	https://maude.cs.illinois.edu/w/images/d/d3/${MY_P}.tar.gz
	https://maude.cs.illinois.edu/w/images/0/0a/Full-${MY_P}.zip
	doc? ( https://maude.cs.illinois.edu/w/images/6/62/${MY_P}-manual.pdf )
	examples? ( https://maude.cs.illinois.edu/w/images/4/4f/${MY_P}-manual-book-examples.zip )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

RDEPEND="
	dev-libs/gmp:=[cxx(+)]
	dev-libs/libtecla
	sci-libs/buddy"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip
	sys-devel/bison
	sys-devel/flex"

PATCHES=(
	"${FILESDIR}/${PN}-2.6-search-datadir.patch"
	"${FILESDIR}/${PN}-2.7-AR.patch"
	"${FILESDIR}/${PN}-3.1-prll.patch"
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
	newins "${WORKDIR}"/full-maude${PV//./}.maude full-maude.maude

	# install docs and examples
	use doc && dodoc "${DISTDIR}"/${MY_P}-manual.pdf
	if use examples; then
		dodoc -r "${WORKDIR}"/examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
