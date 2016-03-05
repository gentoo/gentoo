# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="konsole"
KDE_HANDBOOK="never"
VIRTUALX_REQUIRED="test"
VIRTUALDBUS_TEST="true"
inherit kde4-base

DESCRIPTION="X terminal kpart for use by konsole and other KDE applications"
HOMEPAGE="https://www.kde.org/applications/system/konsole https://konsole.kde.org"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug minimal"

COMMONDEPEND="
	!aqua? (
		x11-libs/libX11
		x11-libs/libXext
		>=x11-libs/libxklavier-3.2
		x11-libs/libXrender
		x11-libs/libXtst
		!minimal? ( $(add_kdeapps_dep libkonq) )
	)
"
DEPEND="${COMMONDEPEND}
	!aqua? (
		x11-apps/bdftopcf
		x11-proto/kbproto
		x11-proto/renderproto
	)
"
RDEPEND="${COMMONDEPEND}
	!<kde-apps/konsole-4.14.3-r2
"

# can't connect to a kded instance, fails to connect to dbus
RESTRICT="test"

S="${WORKDIR}/${KMNAME}-${PV}"

src_prepare() {
	comment_add_subdirectory doc/manual

	kde4-base_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with "!minimal" LibKonq)
	)

	kde4-base_src_configure
}

src_install() {
	kde4-base_src_install

	rm -r "${ED}"usr/bin || die
	rm -r "${ED}"usr/share/applications || die
	rm "${ED}"usr/share/kde4/services/ServiceMenus/konsolehere.desktop || die
	rm "${ED}"usr/share/kde4/services/ServiceMenus/konsolerun.desktop || die
}
