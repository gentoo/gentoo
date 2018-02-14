# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Qt SQL driver plugin for SQLCipher"
HOMEPAGE="https://github.com/blizzard4591/qt5-sqlcipher"
SRC_URI="https://dev.gentoo.org/~ulm/distfiles/${P}.tar.xz"

LICENSE="LGPL-2.1" # version 2.1 only
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=dev-db/sqlcipher-3.4.1
	>=dev-qt/qtcore-5.7.1:5=
	>=dev-qt/qtsql-5.7.1:5=[sqlite]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"
DOCS=(README.md)

src_prepare() {
	eapply "${FILESDIR}"/${PN}-install-path.patch
	sed -i -e "s/@LIBDIR@/$(get_libdir)/" CMakeLists.txt || die
	# workaround for bug 647624 (Qt 5.9.3 and 5.9.4 files are identical)
	cp -R qt-file-cache/5.9.{3,4} || die
	cmake-utils_src_prepare
}

src_test() {
	cd "${BUILD_DIR}" || die
	./qsqlcipher-test || die
}
