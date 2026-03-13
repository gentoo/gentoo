# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop flag-o-matic toolchain-funcs

DESCRIPTION="X Window block dropping game in 3 Dimension"
HOMEPAGE="https://perso.univ-lyon1.fr/thierry.excoffier/XBL/"
SRC_URI="https://perso.univ-lyon1.fr/thierry.excoffier/XBL/xbl-${PV}.tar.gz"
S="${WORKDIR}/xbl-${PV}"

LICENSE="GPL-1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-font.patch
	"${FILESDIR}"/${P}-configure-clang16.patch
	"${FILESDIR}"/${P}-makefile.patch
)

src_prepare() {
	default

	# Don't know about other archs. --slarti
	use amd64 && filter-flags "-fweb"

	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	append-cflags -std=gnu17 #946934
	default
}

src_compile() {
	emake \
		USE_SETGID= \
		SCOREDIR="${EPREFIX}/usr/share/${PN}" \
		RESOURCEDIR="${EPREFIX}/usr/share/${PN}" \
		LDOPTIONS="${LDFLAGS}" \
		GENTOO_CFLAGS="${CFLAGS}" \
		CC="$(tc-getCC)"
}

src_install() {
	newbin bl xbl

	insinto /usr/share/${PN}
	newins Xbl.ad Xbl

	newman xbl.man xbl.6
	dodoc README xbl-README
	HTML_DOCS="*.html *.gif" einstalldocs

	newicon xbl-game.gif ${PN}.gif
	make_desktop_entry xbl XBlockOut /usr/share/pixmaps/${PN}.gif
}
