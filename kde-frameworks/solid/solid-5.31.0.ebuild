# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Provider for platform independent hardware discovery, abstraction and management"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="nls"

RDEPEND="
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	sys-fs/udisks:2
	virtual/udev
"
DEPEND="${RDEPEND}
	nls? ( $(add_qt_dep linguist-tools) )
	test? ( $(add_qt_dep qtconcurrent) )
"
pkg_postinst() {
	kde5_pkg_postinst

	if ! has_version "app-misc/media-player-info" ; then
		einfo "For media player support, install app-misc/media-player-info"
	fi
}
