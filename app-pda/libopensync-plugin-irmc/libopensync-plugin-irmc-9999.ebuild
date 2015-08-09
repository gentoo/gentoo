# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit eutils cmake-utils subversion

DESCRIPTION="OpenSync IrMC plugin"
HOMEPAGE="http://www.opensync.org/"
SRC_URI=""

ESVN_REPO_URI="http://svn.opensync.org/plugins/irmc-sync"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE="bluetooth irda"

REQUIRED_USE="|| ( bluetooth irda )"

RDEPEND="~app-pda/libopensync-${PV}
	dev-libs/glib:2
	dev-libs/libxml2
	>=dev-libs/openobex-1.0[bluetooth?,irda?]
	bluetooth? ( net-wireless/bluez )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_compile() {
	local mycmakeargs="
		$(cmake-utils_use_enable bluetooth BLUETOOTH)
		$(cmake-utils_use_enable irda IRDA)"

	cmake-utils_src_compile
}
