# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Compact and open-source SMT-solver written in C++"
HOMEPAGE="http://verify.inf.usi.ch/opensmt/
	https://github.com/usi-verification-and-security/opensmt/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/usi-verification-and-security/${PN}"
else
	SRC_URI="https://github.com/usi-verification-and-security/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0/${PV}"
IUSE="debug libedit test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/gmp:=[cxx]
	libedit? ( dev-libs/libedit:= )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	app-alternatives/yacc
	app-alternatives/lex
	test? ( dev-cpp/gtest )
"

PATCHES=(
	"${FILESDIR}/opensmt-2.7.0-cmake_minimum.patch"
)

src_prepare() {
	cmake_src_prepare

	echo "add_subdirectory(unit)" > "${S}/test/CMakeLists.txt" || die
}

src_configure() {
	local CMAKE_BUILD_TYPE=""
	if use debug ; then
		CMAKE_BUILD_TYPE="Debug"
	else
		CMAKE_BUILD_TYPE="Release"
	fi

	local -a mycmakeargs=(
		-DENABLE_LINE_EDITING="$(usex libedit)"
		-DPACKAGE_TESTS="$(usex test)"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	if use elibc_glibc ; then
		dolib.so "${ED}/usr/lib/libopensmt.so"*
		rm "${ED}/usr/lib/libopensmt.so"* || die
	fi

	rm "${ED}/usr/lib/libopensmt.a" || die
}
