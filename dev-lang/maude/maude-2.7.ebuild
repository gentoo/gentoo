# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="High-level specification language for equational and logic programming"
HOMEPAGE="http://maude.cs.uiuc.edu/"
SRC_URI="
	http://maude.cs.illinois.edu/w/images/2/2d/${P^}.tar.gz
	https://dev.gentoo.org/~jlec/distfiles/${PN}-2.6-extras.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples"

RDEPEND="
	dev-libs/gmp:0=[cxx]
	dev-libs/libsigsegv
	dev-libs/libtecla
	sci-libs/buddy"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex"

S="${WORKDIR}/${P^}"

PATCHES=(
	"${FILESDIR}/${PN}-2.5.0-prll.patch"
	"${FILESDIR}/${PN}-2.6-search-datadir.patch"
	"${FILESDIR}/${PN}-2.7-bison-parse-param.patch"
)

src_prepare() {
	default
	sed -i -e "s:/usr:${EPREFIX}/usr:g" src/Mixfix/global.hh || die
	eautoreconf
}

src_install() {
	default

	# install data and full maude
	insinto /usr/share/${PN}
	doins -r src/Main/*.maude
	doins "${WORKDIR}"/${PN}-2.6-extras/full-maude.maude

	# install docs and examples
	use doc && dodoc -r "${WORKDIR}"/${PN}-2.6-extras/pdfs/.
	if use examples; then
		docinto examples
		dodoc -r "${WORKDIR}"/${PN}-2.6-extras/{manual,primer}-examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
