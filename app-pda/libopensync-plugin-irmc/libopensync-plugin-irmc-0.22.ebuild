# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/libopensync-plugin-irmc/libopensync-plugin-irmc-0.22.ebuild,v 1.5 2012/05/03 20:20:58 jdhore Exp $

EAPI="4"

DESCRIPTION="OpenSync IrMC plugin"
HOMEPAGE="http://www.opensync.org/"
SRC_URI="http://www.opensync.org/download/releases/${PV}/${P}.tar.bz2"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="+bluetooth irda"

REQUIRED_USE="|| ( bluetooth irda )"

RDEPEND="~app-pda/libopensync-${PV}
	dev-libs/glib:2
	dev-libs/libxml2
	>=dev-libs/openobex-1.0[bluetooth?,irda?]
	bluetooth? ( net-wireless/bluez )"

DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	econf \
		$(use_enable bluetooth) \
		$(use_enable irda)
}

src_install() {
	emake DESTDIR="${D}" install
	find "${D}" -name '*.la' -exec rm -f {} + || die
	dodoc AUTHORS README
}
