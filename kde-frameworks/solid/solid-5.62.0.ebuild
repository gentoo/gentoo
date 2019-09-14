# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Provider for platform independent hardware discovery, abstraction and management"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="nls"

BDEPEND="
	nls? ( $(add_qt_dep linguist-tools) )
"
RDEPEND="
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	sys-fs/udisks:2
	virtual/libudev:=
"
DEPEND="${RDEPEND}
	test? ( $(add_qt_dep qtconcurrent) )
"

pkg_postinst() {
	kde5_pkg_postinst

	if [[ -z "${REPLACING_VERSIONS}" ]] && ! has_version "app-misc/media-player-info" ; then
		elog "For media player support, install app-misc/media-player-info"
	fi
}
