# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KDE_HANDBOOK="optional"
KDE_DOC_DIRS="doc/manual"
VIRTUALX_REQUIRED="test"
VIRTUALDBUS_TEST="true"
inherit kde4-base

DESCRIPTION="X terminal for use with KDE"
HOMEPAGE="https://www.kde.org/applications/system/konsole https://konsole.kde.org"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug minimal"

COMMONDEPEND="
	!aqua? (
		$(add_kdeapps_dep libkonq)
		x11-libs/libX11
		x11-libs/libXext
		>=x11-libs/libxklavier-3.2
		x11-libs/libXrender
		x11-libs/libXtst
	)
"
DEPEND="${COMMONDEPEND}
	!aqua? (
		x11-apps/bdftopcf
		x11-proto/kbproto
		x11-proto/renderproto
	)
"
RDEPEND="${COMMONDEPEND}"

# can't connect to a kded instance, fails to connect to dbus
RESTRICT="test"

src_install() {
	kde4-base_src_install

	if use minimal; then
		rm "${D}/usr/bin/konsole" || die
		rm "${D}/usr/bin/konsoleprofile" || die
	fi
}
