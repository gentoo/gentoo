# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop

DEB_VER="9"
DESCRIPTION="Put the balls in the pockets of the same color by manipulating a maze of tubes"
HOMEPAGE="http://home-2.consunet.nl/~cb007736/groundhog.html"
SRC_URI="http://home-2.consunet.nl/~cb007736/${P}.tar.gz
	mirror://debian/pool/main/g/groundhog/groundhog_${PV}-${DEB_VER}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls"

RDEPEND="
	x11-libs/gtk+:2
	nls? ( virtual/libintl )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

src_prepare() {
	default

	cd "${WORKDIR}" || die
	eapply groundhog_${PV}-${DEB_VER}.diff

	cd "${S}" || die
	sed -e "s:groundhog-1.4/::" -i \
		"${WORKDIR}"/debian/patches/sv.po.patch || die

	eapply \
		$(sed -e "s:^:${WORKDIR}/debian/patches/:" "${WORKDIR}"/debian/patches/series) \
		"${FILESDIR}"/${P}-flags.patch

	mv configure.in configure.ac || die

	AT_M4DIR="m4" eautoreconf

	sed -i 's:$(localedir):/usr/share/locale:' \
		$(find . -name 'Makefile.in*') || die
}

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	default

	doicon src/pixmaps/${PN}.xpm
	make_desktop_entry ${PN} "Groundhog" /usr/share/pixmaps/${PN}.xpm
}
