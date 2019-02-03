# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CMAKE_MAKEFILE_GENERATOR=emake
inherit cmake-utils

DESCRIPTION="MySQL database connector for C++ (mimics JDBC 4.0 API)"
HOMEPAGE="https://dev.mysql.com/downloads/connector/cpp/"
URI_DIR="Connector-C++"
SRC_URI="https://dev.mysql.com/get/Downloads/${URI_DIR}/${P}-src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="+legacy"

RDEPEND="
	dev-libs/openssl:0=
	dev-libs/protobuf:=
	legacy? ( dev-libs/boost:=
	>=dev-db/mysql-connector-c-6.1.8:= )"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${P}-src"

PATCHES=(
	"${FILESDIR}/8.0.11-fix-build.patch"
)

src_configure() {
	local mycmakeargs=(
		-DWITH_SSL=system
		-DWITH_JDBC=$(usex legacy ON OFF)
	)

	cmake-utils_src_configure
}
