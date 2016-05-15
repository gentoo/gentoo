# Copyright 1999-2016 Gentoo Foundation
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
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND=""
RDEPEND="$(add_kdeapps_dep konsolepart)"

# can't connect to a kded instance, fails to connect to dbus
RESTRICT="test"

src_prepare() {
	comment_add_subdirectory data

	kde4-base_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWITH_LibKonq=OFF
	)

	kde4-base_src_configure
}

src_install() {
	kde4-base_src_install

	rm -r "${ED}"usr/$(get_libdir) || die
	rm -r "${ED}"usr/share/apps || die
	rm "${ED}"usr/share/kde4/services/konsolepart.desktop || die
	rm -r "${ED}"usr/share/kde4/servicetypes || die
}
