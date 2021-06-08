# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit cmake toolchain-funcs python-any-r1 llvm

LLVM_MAX_SLOT=12

DESCRIPTION="Intel SPMD Program Compiler"
HOMEPAGE="https://ispc.github.io/"

if [[ ${PV} = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ispc/ispc.git"
	KEYWORDS=""
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="BSD BSD-2 UoI-NCSA"
SLOT="0"
IUSE="examples"

RDEPEND="<sys-devel/clang-13:="
DEPEND="
	${RDEPEND}
	${PYTHON_DEPS}
	"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
	"

PATCHES=(
	"${FILESDIR}/${PN}-1.13.0-cmake-gentoo-release.patch"
	"${FILESDIR}/${PN}-9999-llvm.patch"
	"${FILESDIR}/${PN}-9999-werror.patch"
)

CMAKE_BUILD_TYPE="RelWithDebInfo"

llvm_check_deps() {
	has_version -d "sys-devel/clang:${LLVM_SLOT}"
}

src_prepare() {
	if use amd64; then
		# On amd64 systems, build system enables x86/i686 build too.
		# This ebuild doesn't even have multilib support, nor need it.
		# https://bugs.gentoo.org/730062
		elog "Removing auto-x86 build on amd64"
		sed -i -e 's:set(target_arch "i686"):return():' cmake/GenerateBuiltins.cmake || die
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		"-DARM_ENABLED=$(usex arm)"
		"-DCMAKE_SKIP_RPATH=ON"
		"-DISPC_NO_DUMPS=ON"
	)
	cmake_src_configure
}

src_install() {
	dobin "${BUILD_DIR}"/bin/ispc
	dodoc README.md

	if use examples; then
		insinto "/usr/share/doc/${PF}/examples"
		docompress -x "/usr/share/doc/${PF}/examples"
		doins -r "${S}"/examples/*
	fi
}

src_test() {
	# Inject path to prevent using system ispc
	PATH="${BUILD_DIR}/bin:${PATH}" ${EPYTHON} ./run_tests.py || die "Testing failed under ${EPYTHON}"
}
