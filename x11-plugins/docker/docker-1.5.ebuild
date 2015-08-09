# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

DESCRIPTION="Openbox app which acts as a system tray for KDE and GNOME2"
HOMEPAGE="http://icculus.org/openbox/2/docker/"
SRC_URI="http://icculus.org/openbox/2/${PN}/${P}.tar.gz"

RDEPEND=">=dev-libs/glib-2.0.4
	x11-libs/libX11
	!app-emulation/docker"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	emake CC="$(tc-getCC)" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc README
}
