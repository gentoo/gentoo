# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Compact and open-source SMT-solver written in C++"
HOMEPAGE="http://verify.inf.usi.ch/opensmt/
	https://github.com/usi-verification-and-security/opensmt/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/usi-verification-and-security/${PN}.git"
else
	SRC_URI="https://github.com/usi-verification-and-security/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0/${PV}"
IUSE="debug libedit +readline test"
REQUIRED_USE="?? ( libedit readline )"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/gmp:=[cxx]
	readline? ( sys-libs/readline:= )
	libedit? ( dev-libs/libedit:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
	test? ( dev-cpp/gtest )
"

# PATCHES=( "${FILESDIR}"/${PN}-2.4.3-musl.patch )

src_prepare() {
	cmake_src_prepare

	echo "add_subdirectory(unit)" > "${S}"/test/CMakeLists.txt || die
}

src_configure() {
	local CMAKE_BUILD_TYPE
	if use debug ; then
		CMAKE_BUILD_TYPE=Debug
	else
		CMAKE_BUILD_TYPE=Release
	fi

	local -a mycmakeargs=(
		-DPACKAGE_TESTS=$(usex test)
		-DUSE_READLINE=$(usex readline)
	)
	if use readline || use libedit ; then
		mycmakeargs+=( -DENABLE_LINE_EDITING=ON )
	fi
	cmake_src_configure
}

src_install() {
	cmake_src_install

	rm "${ED}"/usr/lib/libopensmt.a || die
	dodir /usr/$(get_libdir)
	mv "${ED}"/usr/lib/libopensmt.* "${ED}"/usr/$(get_libdir)/ || die
}
