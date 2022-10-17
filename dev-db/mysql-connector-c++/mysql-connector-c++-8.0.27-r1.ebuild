# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CMAKE_MAKEFILE_GENERATOR=emake
inherit cmake

DESCRIPTION="MySQL database connector for C++ (mimics JDBC 4.0 API)"
HOMEPAGE="https://dev.mysql.com/downloads/connector/cpp/"
URI_DIR="Connector-C++"
SRC_URI="https://dev.mysql.com/get/Downloads/${URI_DIR}/${P}-src.tar.gz"

LICENSE="Artistic GPL-2"
SLOT="0"
# -ppc, -sparc for bug #711940
KEYWORDS="~amd64 ~arm ~arm64 -ppc ~ppc64 -sparc ~x86"
IUSE="+legacy"

RDEPEND="
	dev-libs/protobuf:=
	legacy? (
		dev-libs/boost:=
		>=dev-db/mysql-connector-c-8.0.27:=
	)
	dev-libs/openssl:0=
	"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${P}-src"

PATCHES=(
	"${FILESDIR}"/${PN}-8.0.27-fix-build.patch
	"${FILESDIR}"/${PN}-8.0.27-mysqlclient_r.patch
)

src_configure() {
	local mycmakeargs=(
		-DWITH_SSL=system
		-DWITH_JDBC=$(usex legacy ON OFF)
		$(usex legacy '-DMYSQLCLIENT_STATIC_BINDING=0' '')
		$(usex legacy '-DMYSQLCLIENT_STATIC_LINKING=0' '')
	)

	cmake_src_configure
}
