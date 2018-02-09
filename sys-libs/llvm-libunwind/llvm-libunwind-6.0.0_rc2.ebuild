# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

: ${CMAKE_MAKEFILE_GENERATOR:=ninja}
# (needed due to CMAKE_BUILD_TYPE != Gentoo)
CMAKE_MIN_VERSION=3.7.0-r1
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
inherit cmake-multilib llvm python-any-r1

MY_P=libunwind-${PV/_/}.src
LIBCXX_P=libcxx-${PV/_/}.src

DESCRIPTION="C++ runtime stack unwinder from LLVM"
HOMEPAGE="https://github.com/llvm-mirror/libunwind"
SRC_URI="http://prereleases.llvm.org/${PV/_//}/${MY_P}.tar.xz
	test? ( http://prereleases.llvm.org/${PV/_//}/${LIBCXX_P}.tar.xz )"

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS=""
IUSE="debug +static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="!sys-libs/libunwind"
# llvm-6 for new lit options
DEPEND="
	>=sys-devel/llvm-6
	test? (
		sys-libs/libcxx[${MULTILIB_USEDEP}]
		$(python_gen_any_dep 'dev-python/lit[${PYTHON_USEDEP}]') )"

S=${WORKDIR}/${MY_P}

# least intrusive of all
CMAKE_BUILD_TYPE=RelWithDebInfo

python_check_deps() {
	has_version "dev-python/lit[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_unpack() {
	einfo "Unpacking ${MY_P}.tar.xz ..."
	tar -xf "${DISTDIR}/${MY_P}.tar.xz" || die

	if use test; then
		einfo "Unpacking parts of ${LIBCXX_P}.tar.xz ..."
		tar -xf "${DISTDIR}/${LIBCXX_P}.tar.xz" \
			"${LIBCXX_P}"/{include,utils/libcxx} || die
		mv "${LIBCXX_P}" libcxx || die
	fi
}

multilib_src_configure() {
	local libdir=$(get_libdir)

	local mycmakeargs=(
		-DLLVM_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBUNWIND_ENABLE_ASSERTIONS=$(usex debug)
		-DLIBUNWIND_ENABLE_STATIC=$(usex static-libs)
		-DLLVM_INCLUDE_TESTS=$(usex test)

		# support non-native unwinding; given it's small enough,
		# enable it unconditionally
		-DLIBUNWIND_ENABLE_CROSS_UNWINDING=ON
	)
	if use test; then
		mycmakeargs+=(
			-DLLVM_EXTERNAL_LIT="${EPREFIX}/usr/bin/lit"
			-DLLVM_LIT_ARGS="-vv"
			-DLIBUNWIND_LIBCXX_PATH="${WORKDIR}"/libcxx
		)
	fi

	cmake-utils_src_configure
}

multilib_src_test() {
	cmake-utils_src_make check-unwind
}

multilib_src_install() {
	cmake-utils_src_install

	# install headers like sys-libs/libunwind
	doheader "${S}"/include/*.h
}
