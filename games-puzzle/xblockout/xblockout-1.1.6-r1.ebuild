# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools desktop flag-o-matic

DESCRIPTION="X Window block dropping game in 3 Dimension"
HOMEPAGE="http://perso.univ-lyon1.fr/thierry.excoffier/XBL/"
SRC_URI="http://perso.univ-lyon1.fr/thierry.excoffier/XBL/xbl-${PV}.tar.gz"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/xbl-${PV}"

src_prepare() {
	default
	eapply "${FILESDIR}"/${P}-font.patch
	sed -i \
		-e '/^CC/d' \
		-e 's:-lm:-lm -lX11:' \
		-e '/DGROUP_GID/d' \
		-e "s:-g$:${CFLAGS}:" \
		Makefile.in || die
	# Don't know about other archs. --slarti
	use amd64 && filter-flags "-fweb"

	mv configure.in configure.ac || die
	eautoreconf
}

src_compile() {
	emake \
		USE_SETGID= \
		SCOREDIR="/usr/share/${PN}" \
		RESOURCEDIR="/usr/share/${PN}" \
		LDOPTIONS="${LDFLAGS}"
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
