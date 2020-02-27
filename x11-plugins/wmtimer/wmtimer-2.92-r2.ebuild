# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit multilib toolchain-funcs

DESCRIPTION="Dockable clock which can run in alarm, countdown timer or chronograph mode"
HOMEPAGE="https://github.com/bbidulock/wmtimer"
SRC_URI="https://github.com/bbidulock/wmtimer/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~sparc x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2
	x11-libs/gtk+:2
	x11-libs/libXpm
	x11-libs/libXext
	x11-libs/libX11"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${P}/${PN}

src_prepare() {
	sed -i -e "s|\$(CFLAGS)||" Makefile || die
	sed -i -e "s|-g||g" Makefile || die
	sed -i -e "s|-O2|\$(CFLAGS) ${CFLAGS}|"  Makefile || die
	sed -i -e "s|-o wmtimer|\$(LDFLAGS) -o wmtimer|" Makefile || die

	cd "${WORKDIR}"/${P} || die
	eapply "${FILESDIR}"/${P}-counter-fix.patch
	eapply "${FILESDIR}"/${P}-list.patch
	eapply "${FILESDIR}"/${P}-gcc-10.patch
	eapply_user
}

src_compile() {
	emake CC="$(tc-getCC)" LIBDIR="-L/usr/$(get_libdir)"
}

src_install() {
	dobin wmtimer
	dodoc ../{Changelog,CREDITS,README}
}
