# Copyright 1999-2024 Gentoo Authors
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
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~x86"
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

src_configure() {
	local mycmakeargs=(
		-DENABLE_FMT_LAYOUT=ON
		-DLOG4CXX_QT_SUPPORT=OFF
		-DLOG4CXX_ENABLE_ODBC=$(usex odbc ON OFF)
		-DLOG4CXX_ENABLE_ESMTP=$(usex smtp ON OFF)
	)

	cmake_src_configure
}
