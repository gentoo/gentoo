# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EBZR_REPO_URI="lp:libdbusmenu-qt"

[[ ${PV} == 9999* ]] && inherit bzr
inherit cmake-utils virtualx

DESCRIPTION="Library providing Qt implementation of DBusMenu specification"
HOMEPAGE="https://launchpad.net/libdbusmenu-qt/"
if [[ ${PV} != 9999* ]] ; then
	MY_PV=${PV/_pre/+16.04.}
	SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+files/${PN}_${MY_PV}.orig.tar.gz"
	KEYWORDS="amd64 ~arm arm64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
fi

LICENSE="LGPL-2"
SLOT="0"
IUSE="debug"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )
"

[[ ${PV} == 9999* ]] || S=${WORKDIR}/${PN}-${MY_PV}

# tests fail due to missing connection to dbus
RESTRICT="test"

src_prepare() {
	[[ ${PV} == 9999* ]] && bzr_src_prepare
	cmake-utils_src_prepare

	cmake_comment_add_subdirectory tools
	use test || cmake_comment_add_subdirectory tests
}

src_configure() {
	local mycmakeargs=(
		-DWITH_DOC=OFF
		-DUSE_QT5=ON
	)
	cmake-utils_src_configure
}

src_test() {
	local builddir=${BUILD_DIR}

	BUILD_DIR=${BUILD_DIR}/tests virtx cmake-utils_src_test

	BUILD_DIR=${builddir}
}
