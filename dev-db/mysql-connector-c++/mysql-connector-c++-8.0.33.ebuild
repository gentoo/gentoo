# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR=emake
inherit cmake

URI_DIR="Connector-C++"
DESCRIPTION="MySQL database connector for C++ (mimics JDBC 4.0 API)"
HOMEPAGE="https://dev.mysql.com/downloads/connector/cpp/"
SRC_URI="https://dev.mysql.com/get/Downloads/${URI_DIR}/${P}-src.tar.gz"
S="${WORKDIR}/${P}-src"

LICENSE="Artistic GPL-2"
SLOT="0"
# -ppc, -sparc for bug #711940
KEYWORDS="~amd64 ~arm ~arm64 -ppc ~ppc64 -sparc ~x86"

RDEPEND="
	app-arch/lz4:=
	app-arch/zstd:=
	dev-libs/openssl:=
	sys-libs/zlib
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-8.0.27-mysqlclient_r.patch
)

src_configure() {
	local mycmakeargs=(
		-DBUNDLE_DEPENDENCIES=OFF
		# Cannot handle protobuf >23, bug #912797
		#-DWITH_PROTOBUF=system
		-DWITH_LZ4=system
		-DWITH_SSL=system
		-DWITH_ZLIB=system
		-DWITH_ZSTD=system
		-DWITH_JDBC=OFF
	)

	cmake_src_configure
}
