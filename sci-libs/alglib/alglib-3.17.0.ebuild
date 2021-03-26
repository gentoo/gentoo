# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic

DESCRIPTION="Numerical analysis and data processing library"
HOMEPAGE="https://www.alglib.net/"
SRC_URI="https://www.alglib.net/translator/re/${P}.cpp.gpl.tgz"
S="${WORKDIR}"/cpp

LICENSE="GPL-2+"
SLOT="0/3.8"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

src_prepare() {
	cp "${FILESDIR}"/CMakeLists.txt-3.8.2 CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	use x86 && append-cflags -ffloat-store
	local mycmakeargs=(
		-DBUILD_TEST=$(usex test)
	)
	cmake_src_configure
}
