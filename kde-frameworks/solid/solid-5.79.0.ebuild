# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

QTMIN=5.15.2
VIRTUALX_REQUIRED="test"
inherit ecm kde.org optfeature

DESCRIPTION="Provider for platform independent hardware discovery, abstraction and management"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="ios nls"

BDEPEND="
	sys-devel/bison
	sys-devel/flex
	nls? ( >=dev-qt/linguist-tools-${QTMIN}:5 )
"
RDEPEND="
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5
	>=dev-qt/qtxml-${QTMIN}:5
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

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package ios IMobileDevice)
		$(cmake_use_find_package ios PList)
	)
	ecm_src_configure
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "Optional dependencies:"
		optfeature "Media player devices support" app-misc/media-player-info
	fi
	ecm_pkg_postinst
}
