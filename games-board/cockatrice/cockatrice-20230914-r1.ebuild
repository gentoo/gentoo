# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake optfeature xdg

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
	dev-qt/qtbase:6[network,ssl,widgets]
	client? (
		dev-qt/qtbase:6[concurrent,gui]
		dev-qt/qtmultimedia:6
		dev-qt/qtsvg:6
		dev-qt/qtwebsockets:6
	)
	oracle? (
		app-arch/xz-utils
		dev-qt/qtbase:6[concurrent]
		dev-qt/qtsvg:6
		sys-libs/zlib
	)
	server? (
		dev-qt/qtbase:6[sql]
		dev-qt/qtwebsockets:6
	)
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )
"
BDEPEND="dev-libs/protobuf:="

PATCHES=(
	"${FILESDIR}/${PN}-2.9.0-support-protobuf-23.patch"
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF # This is need because [upstream's CMake needs fixing]
		-DUSE_CCACHE=OFF
		-DWITH_CLIENT=$(usex client)
		-DWITH_ORACLE=$(usex oracle)
		-DWITH_SERVER=$(usex server)
		-DTEST=$(usex test)
		-DICONDIR="${EPREFIX}/usr/share/icons"
		-DDESKTOPDIR="${EPREFIX}/usr/share/applications"
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
