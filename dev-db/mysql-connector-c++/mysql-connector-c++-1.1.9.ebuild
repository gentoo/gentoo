# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils flag-o-matic

DESCRIPTION="MySQL database connector for C++ (mimics JDBC 4.0 API)"
HOMEPAGE="http://dev.mysql.com/downloads/connector/cpp/"
URI_DIR="Connector-C++"
SRC_URI="https://dev.mysql.com/get/Downloads/${URI_DIR}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug examples gcov static-libs"

DEPEND="virtual/libmysqlclient:=
	dev-libs/boost:=
	dev-libs/openssl:0=
	!<dev-db/mysql-connector-c-6.1.8"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.1.6-fix-cmake.patch"
	"${FILESDIR}/${PN}-1.1.8-fix-mariadb.patch"
)

src_configure() {
	# native lib/wrapper needs this!
	append-flags "-fno-strict-aliasing"

	local mycmakeargs=(
		-DMYSQLCPPCONN_BUILD_EXAMPLES=OFF
		-DMYSQLCPPCONN_ICU_ENABLE=OFF
		-DUSE_MYSQLCPPCONN_TRACE_ENABLE=$(usex debug ON OFF)
		-DUSE_MYSQLCPPCONN_GCOV_ENABLE=$(usex gcov ON OFF)
		-DINSTALL_DOCS="/usr/share/doc/${PF}"
		-DMYSQL_CXX_LINKAGE=0
		-DMYSQL_INCLUDE_DIR=$(mysql_config --variable=pkgincludedir)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# static lib has wrong name so we need to rename it
	if use static-libs; then
		mv "${ED}"/usr/$(get_libdir)/libmysqlcppconn-static.a \
			"${ED}"/usr/$(get_libdir)/libmysqlcppconn.a || die
	else
		rm -f "${ED}"/usr/$(get_libdir)/libmysqlcppconn-static.a
	fi

	# examples
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins "${S}"/examples/*
	fi
}
