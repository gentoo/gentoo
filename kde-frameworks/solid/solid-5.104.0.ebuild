# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=5.15.5
VIRTUALX_REQUIRED="test"
inherit ecm frameworks.kde.org optfeature

DESCRIPTION="Provider for platform independent hardware discovery, abstraction and management"

LICENSE="LGPL-2.1+"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"
IUSE="ios"

RDEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
	sys-apps/util-linux
	sys-fs/udisks:2
	virtual/libudev:=
	ios? (
		app-pda/libimobiledevice:=
		app-pda/libplist:=
	)
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qtconcurrent-${QTMIN}:5 )
"
BDEPEND="
	>=dev-qt/linguist-tools-${QTMIN}:5
	sys-devel/bison
	sys-devel/flex
"

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package ios IMobileDevice)
		$(cmake_use_find_package ios PList)
	)
	ecm_src_configure
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		optfeature "media player devices support" app-misc/media-player-info
	fi
	ecm_pkg_postinst
}
