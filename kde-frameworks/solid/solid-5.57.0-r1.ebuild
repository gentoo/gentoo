# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VIRTUALX_REQUIRED="test"
inherit kde5

DESCRIPTION="Provider for platform independent hardware discovery, abstraction and management"
LICENSE="LGPL-2.1+"
KEYWORDS="amd64 ~arm arm64 x86"
IUSE="nls udev"

BDEPEND="
	nls? ( $(add_qt_dep linguist-tools) )
"
RDEPEND="
	$(add_qt_dep qtdbus)
	$(add_qt_dep qtdeclarative)
	$(add_qt_dep qtwidgets)
	$(add_qt_dep qtxml)
	sys-fs/udisks:2
	udev? ( virtual/libudev:= )
"
DEPEND="${RDEPEND}
	test? ( $(add_qt_dep qtconcurrent) )
"

src_configure() {
	local mycmakeargs=(
		-DUDEV_DISABLED=$(usex !udev)
	)
	kde5_src_configure
}

pkg_postinst() {
	kde5_pkg_postinst

	if [[ -z "${REPLACING_VERSIONS}" ]] && ! has_version "app-misc/media-player-info" ; then
		elog "For media player support, install app-misc/media-player-info"
	fi

	use udev || ewarn "Building without udev support may cause unintended runtime problems in consumers."
}
