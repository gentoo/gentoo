# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Library routines related to building,parsing and iterating BSON documents"
HOMEPAGE="https://github.com/mongodb/mongo-c-driver/tree/master/src/libbson"
SRC_URI="https://github.com/mongodb/mongo-c-driver/releases/download/${PV}/mongo-c-driver-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc x86"
IUSE="examples static-libs"

DEPEND="dev-python/sphinx"

PATCHES=(
	"${FILESDIR}/${PN}-1.14.0-no-docs.patch"
	"${FILESDIR}/${PN}-1.16.2-single-doc-job.patch"
	"${FILESDIR}/${PN}-1.16.2-sphinx.patch"
)

S="${WORKDIR}/mongo-c-driver-${PV}"

src_configure() {
	local mycmakeargs=(
		-DENABLE_BSON=ON
		-DENABLE_EXAMPLES=OFF
		-DENABLE_MAN_PAGES=ON
		-DENABLE_MONGOC=OFF
		-DENABLE_TESTS=OFF
		-DENABLE_STATIC="$(usex static-libs ON OFF)"
		-DENABLE_UNINSTALL=OFF
	)

	cmake-utils_src_configure
}

src_install() {
	if use examples; then
		docinto examples
		dodoc src/libbson/examples/*.c
	fi

	cmake-utils_src_install
}
