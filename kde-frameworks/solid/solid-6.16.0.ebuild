# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=6.7.2
inherit ecm frameworks.kde.org optfeature

DESCRIPTION="Provider for platform independent hardware discovery, abstraction and management"

LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="ios"

RDEPEND="
	>=dev-qt/qtbase-${QTMIN}:6[dbus,gui,xml]
	>=dev-qt/qtdeclarative-${QTMIN}:6
	sys-apps/util-linux
	sys-fs/udisks:2
	virtual/libudev:=
	ios? (
		app-pda/libimobiledevice:=
		app-pda/libplist:=
	)
"
DEPEND="${RDEPEND}
	test? ( >=dev-qt/qtbase-${QTMIN}:6[concurrent] )
"
BDEPEND="
	app-alternatives/lex
	app-alternatives/yacc
	>=dev-qt/qttools-${QTMIN}:6[linguist]
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
}
