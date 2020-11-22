# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop flag-o-matic toolchain-funcs

DESCRIPTION="X Window block dropping game in 3 Dimension"
HOMEPAGE="http://perso.univ-lyon1.fr/thierry.excoffier/XBL/"
SRC_URI="http://perso.univ-lyon1.fr/thierry.excoffier/XBL/xbl-${PV}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/xbl-${PV}"

PATCHES=(
	"${FILESDIR}"/${P}-font.patch
)

src_prepare() {
	default
	sed -i \
		-e '/^CC/d' \
		-e 's:-lm:-lm -lX11:' \
		-e '/DGROUP_GID/d' \
		-e 's:-g$:$(GENTOO_CFLAGS):' \
		Makefile.in || die
	# Don't know about other archs. --slarti
	use amd64 && filter-flags "-fweb"

	mv configure.in configure.ac || die
	eautoreconf
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
