# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg cmake optfeature

MY_PV="${PV:0:4}-${PV:4:2}-${PV:6:2}-Release-2.9.0"

DESCRIPTION="Open-source multiplatform software for playing card games over a network"
HOMEPAGE="https://github.com/Cockatrice/Cockatrice"
SRC_URI="https://github.com/Cockatrice/Cockatrice/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Cockatrice-${MY_PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+client +oracle test server"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/protobuf:=
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5
	dev-qt/qtwidgets:5
	client? (
		dev-qt/qtconcurrent:5
		dev-qt/qtgui:5
		dev-qt/qtmultimedia:5
		dev-qt/qtprintsupport:5
		dev-qt/qtsvg:5
		dev-qt/qtwebsockets:5
	)
	oracle? (
		dev-qt/qtconcurrent:5
		dev-qt/qtsvg:5
		sys-libs/zlib
		app-arch/xz-utils
	)
	server? (
		dev-qt/qtsql:5
		dev-qt/qtwebsockets:5
	)"
DEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest )"
BDEPEND="
	dev-libs/protobuf:="

PATCHES=(
	"${FILESDIR}/${PN}-2.9.0-support-protobuf-23.patch"
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF # This is need because the default eclass breaks the build
		-DUSE_CCACHE=OFF
		-DWITH_CLIENT=$(usex client)
		-DWITH_ORACLE=$(usex oracle)
		-DWITH_SERVER=$(usex server)
		-DTEST=$(usex test)
		-DICONDIR="${EPREFIX}/usr/share/icons"
		-DDESKTOPDIR="${EPREFIX}/usr/share/applications"
		-DFORCE_USE_QT5=1
		-DUPDATE_TRANSLATIONS=OFF
	)

	# Add date in the help about, come from git originally
	sed -e 's/^set(PROJECT_VERSION_FRIENDLY.*/set(PROJECT_VERSION_FRIENDLY \"'${MY_PV}'\")/' \
		-i cmake/getversion.cmake || die "sed failed!"

	cmake_src_configure
}

pkg_postinst() {
	xdg_pkg_postinst
	optfeature "mysql/mariadb support" dev-db/mysql-connector-c
}
