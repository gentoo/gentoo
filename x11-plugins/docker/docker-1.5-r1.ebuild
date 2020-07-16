# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="Openbox app which acts as a system tray for KDE and GNOME2"
HOMEPAGE="https://icculus.org/openbox/2/docker/"
SRC_URI="https://icculus.org/openbox/2/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2.0.4
	x11-libs/libX11"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}/${P}-makefile_rename.patch"
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README
}

pkg_postinst() {
	einfo "To avoid collision with app-emulation/docker, binary was renamed to wmdocker"
}
