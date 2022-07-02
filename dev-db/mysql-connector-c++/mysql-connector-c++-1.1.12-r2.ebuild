# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="MySQL database connector for C++ (mimics JDBC 4.0 API)"
HOMEPAGE="https://dev.mysql.com/downloads/connector/cpp/"
SRC_URI="https://dev.mysql.com/get/Downloads/Connector-C++/${P}.tar.gz"

LICENSE="Artistic GPL-2"
SLOT="0/7"
KEYWORDS="amd64 arm ~arm64 ~ppc ppc64 sparc x86"
IUSE="debug examples gcov"

DEPEND="
	dev-db/mysql-connector-c:=
	dev-libs/boost:=
	dev-libs/openssl:0=
	!<dev-db/mysql-connector-c-6.1.8"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.1.6-fix-cmake.patch"
	"${FILESDIR}/${PN}-1.1.11-fix-mariadb.patch"
)

src_configure() {
	# native lib/wrapper needs this!
	append-flags -fno-strict-aliasing

	local mycmakeargs=(
		-DMYSQLCPPCONN_BUILD_EXAMPLES=OFF
		-DMYSQLCPPCONN_ICU_ENABLE=OFF
		-DMYSQLCPPCONN_TRACE_ENABLE=$(usex debug)
		-DMYSQLCPPCONN_GCOV_ENABLE=$(usex gcov)
		-DINSTALL_DOCS="share/doc/${PF}"
		-DMYSQL_CXX_LINKAGE=0
		-DMYSQL_INCLUDE_DIR=$(mysql_config --variable=pkgincludedir)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	rm "${ED}"/usr/$(get_libdir)/libmysqlcppconn-static.a || die

	# examples
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
