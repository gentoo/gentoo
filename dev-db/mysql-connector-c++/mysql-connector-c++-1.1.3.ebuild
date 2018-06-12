# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils cmake-utils flag-o-matic multilib

DESCRIPTION="MySQL database connector for C++ (mimics JDBC 4.0 API)"
HOMEPAGE="https://dev.mysql.com/downloads/connector/cpp/"
URI_DIR="Connector-C++"
SRC_URI="https://dev.mysql.com/get/Downloads/${URI_DIR}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 sparc x86"
IUSE="debug examples gcov static-libs"

DEPEND=">=virtual/mysql-5.1:=
	dev-libs/boost:0=
	dev-libs/openssl:0="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-1.1.3-fix-cmake.patch"
)

src_configure() {
	# native lib/wrapper needs this!
	append-flags "-fno-strict-aliasing"

	local mycmakeargs=(
		"-DMYSQLCPPCONN_BUILD_EXAMPLES=OFF"
		"-DMYSQLCPPCONN_ICU_ENABLE=OFF"
		$(cmake-utils_use debug MYSQLCPPCONN_TRACE_ENABLE)
		$(cmake-utils_use gcov MYSQLCPPCONN_GCOV_ENABLE)
		-DINSTALL_DOCS="/usr/share/doc/${PF}"
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
