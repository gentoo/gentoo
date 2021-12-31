# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Simple Theorem Prover, an efficient SMT solver for bitvectors"
HOMEPAGE="https://stp.github.io/"
SRC_URI="https://github.com/stp/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2+ MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="python static test"

DEPEND="
	sci-mathematics/minisat
"
RDEPEND="${DEPEND}"

src_prepare() {
	# replace static lib with $(get_libdir)
	sed -i "s/set(LIBDIR lib/set(LIBDIR $(get_libdir)/" CMakeLists.txt || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_ASSERTIONS="$(usex test)"
		-DENABLE_TESTING="$(usex test)"
		-DENABLE_PYTHON_INTERFACE="$(usex python)"
		-DSTATICCOMPILE="$(usex static)"
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	# don't install to /usr/man
	doman "${D}/usr/man/man1/stp.1" || die
	rm -r "${D}/usr/man" || die
}
