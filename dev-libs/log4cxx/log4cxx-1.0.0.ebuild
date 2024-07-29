# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_P=apache-${P}
DESCRIPTION="Library of C++ classes for logging to files, syslog and other destinations"
HOMEPAGE="https://logging.apache.org/log4cxx/"
SRC_URI="mirror://apache/logging/${PN}/${PV}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="Apache-2.0"
SLOT="0/15"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="odbc smtp test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/apr:1=
	dev-libs/apr-util:1=
	dev-libs/libfmt:=
	odbc? ( dev-db/unixODBC )
	smtp? ( net-libs/libesmtp )
"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/zip
	test? (
		app-alternatives/gzip
		app-arch/zip
	)
"

src_prepare() {
	# https://github.com/apache/logging-log4cxx/issues/189
	if ! use odbc ; then
		sed -i -e 's:pkg_check_modules( odbc QUIET odbc ):pkg_check_modules( odbc QUIET odbcDoNotFindMe ):' src/main/include/CMakeLists.txt || die
	fi

	if ! use smtp ; then
		sed -i -e 's:CHECK_LIBRARY_EXISTS(esmtp smtp_create_session "" HAS_LIBESMTP):CHECK_LIBRARY_EXISTS(esmtpDoNotFindMe smtp_create_session "" HAS_LIBESMTP):' src/main/include/CMakeLists.txt || die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_FMT_LAYOUT=ON
		-DLOG4CXX_QT_SUPPORT=OFF
	)

	cmake_src_configure
}
