# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

VALA_MIN_API_VERSION="0.14"
VALA_MAX_API_VERSION="0.20"

inherit vala autotools eutils

DESCRIPTION="LXDE session manager (lite version)"
HOMEPAGE="http://lxde.sf.net/"
SRC_URI="mirror://sourceforge/lxde/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~ppc ~x86 ~arm-linux ~x86-linux"
SLOT="0"
# upower USE flag is enabled by default in the desktop profile
IUSE="nls upower"

COMMON_DEPEND="dev-libs/glib:2
	dev-libs/libgee:0
	dev-libs/dbus-glib
	lxde-base/lxde-common
	sys-auth/polkit
	x11-libs/gtk+:2
	x11-libs/libX11
	sys-apps/dbus"
RDEPEND="${COMMON_DEPEND}
	!lxde-base/lxsession-edit
	upower? ( || ( sys-power/upower sys-power/upower-pm-utils ) )"
DEPEND="${COMMON_DEPEND}
	$(vala_depend)
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
	x11-proto/xproto"

DOCS="AUTHORS ChangeLog README"

src_prepare() {
	# bug #488082
	epatch "${FILESDIR}"/${P}-makefile.patch

	eautoreconf
}

src_configure() {
	# dbus is used for restart/shutdown (CK, logind?), and suspend/hibernate (UPower)
	econf \
		$(use_enable nls)
}
