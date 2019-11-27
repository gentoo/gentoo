# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit cmake-utils flag-o-matic

DESCRIPTION="MySQL database connector for C++ (mimics JDBC 4.0 API)"
HOMEPAGE="https://dev.mysql.com/downloads/connector/cpp/"
URI_DIR="Connector-C++"
SRC_URI="https://dev.mysql.com/get/Downloads/${URI_DIR}/${P}.tar.gz"

LICENSE="Artistic GPL-2"
SLOT="0/7"
KEYWORDS="amd64 arm ~arm64 ppc ppc64 sparc x86"
IUSE="debug examples gcov libressl static-libs"

DEPEND="dev-db/mysql-connector-c:=
	dev-libs/boost:=
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	!<dev-db/mysql-connector-c-6.1.8"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.1.6-fix-cmake.patch"
	"${FILESDIR}/${PN}-1.1.11-fix-mariadb.patch"
)

src_configure() {
	# native lib/wrapper needs this!
	append-flags "-fno-strict-aliasing"

	local mycmakeargs=(
		-DMYSQLCPPCONN_BUILD_EXAMPLES=OFF
		-DMYSQLCPPCONN_ICU_ENABLE=OFF
		-DMYSQLCPPCONN_TRACE_ENABLE=$(usex debug ON OFF)
		-DMYSQLCPPCONN_GCOV_ENABLE=$(usex gcov ON OFF)
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
		mv "${ED%/}"/usr/$(get_libdir)/libmysqlcppconn-static.a \
			"${ED%/}"/usr/$(get_libdir)/libmysqlcppconn.a || die
	else
		rm -f "${ED%/}"/usr/$(get_libdir)/libmysqlcppconn-static.a
	fi

	# examples
	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins "${S}"/examples/*
	fi
}
