# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

CMAKE_MAKEFILE_GENERATOR=emake
inherit cmake-utils

DESCRIPTION="MySQL database connector for C++ (mimics JDBC 4.0 API)"
HOMEPAGE="https://dev.mysql.com/downloads/connector/cpp/"
URI_DIR="Connector-C++"
SRC_URI="https://dev.mysql.com/get/Downloads/${URI_DIR}/${P}-src.tar.gz"

LICENSE="Artistic GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="+legacy"

RDEPEND="
	dev-libs/protobuf:=
	legacy? (
		dev-libs/boost:=
		>=dev-db/mysql-connector-c-6.1.8:=
	)
	dev-libs/openssl:0=
	"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${P}-src"

PATCHES=(
	"${FILESDIR}"/${PN}-8.0.19-fix-build.patch
)

src_configure() {
	local mycmakeargs=(
		-DWITH_SSL=system
		-DWITH_JDBC=$(usex legacy ON OFF)
		$(usex legacy '-DMYSQLCLIENT_STATIC_BINDING=0' '')
		$(usex legacy '-DMYSQLCLIENT_STATIC_LINKING=0' '')
	)

	cmake-utils_src_configure
}
