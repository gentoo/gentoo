# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils flag-o-matic

DESCRIPTION="Numerical analysis and data processing library"
HOMEPAGE="http://www.alglib.net/"
SRC_URI="http://www.alglib.net/translator/re/${P}.cpp.gpl.tgz"

SLOT="0/3.8"
LICENSE="GPL-2+"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

S="${WORKDIR}"/cpp/

PATCHES=( "${FILESDIR}/${P}-disable-minlm-test.patch" )

src_prepare() {
	cp "${FILESDIR}"/CMakeLists.txt-3.8.2 CMakeLists.txt || die
	use x86 && append-cppflags -ffloat-store
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TEST=$(usex test)
	)
	cmake-utils_src_configure
}
