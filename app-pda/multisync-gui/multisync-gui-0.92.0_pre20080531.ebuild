# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/multisync-gui/multisync-gui-0.92.0_pre20080531.ebuild,v 1.5 2014/04/06 07:09:03 ssuominen Exp $

EAPI=5
inherit cmake-utils

DESCRIPTION="OpenSync multisync-gui"
HOMEPAGE="http://www.opensync.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

RDEPEND="~app-pda/libopensync-0.36
	>=dev-libs/libxml2-2.6.30
	>=gnome-base/libglade-2.6.2:2.0
	>=x11-libs/gtk+-2.21:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-0.92.0-cmake.patch \
		"${FILESDIR}"/${PN}-0.92.0-pixbuf-include.patch
}
