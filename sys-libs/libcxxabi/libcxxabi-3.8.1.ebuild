# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-multilib

DESCRIPTION="New implementation of low level support for a standard C++ library"
HOMEPAGE="http://libcxxabi.llvm.org/"
SRC_URI="http://llvm.org/releases/${PV}/${P}.src.tar.xz
	http://llvm.org/releases/${PV}/libcxx-${PV}.src.tar.xz"
S="${WORKDIR}/${P}.src"
LIBCXX_S="${WORKDIR}/libcxx-${PV}.src"

LICENSE="|| ( UoI-NCSA MIT )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="elibc_musl libunwind +static-libs"

DEPEND="libunwind? ( ~sys-libs/llvm-libunwind-${PV}[static-libs?,${MULTILIB_USEDEP}] )"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	# to support standalone build
	eapply "${FILESDIR}/${PN}-3.8-cmake.patch"

	if use elibc_musl; then
		pushd ${LIBCXX_S} >/dev/null || die
		eapply "${FILESDIR}/libcxx-3.8-musl-support.patch"
		popd >/dev/null || die
	fi
}

multilib_src_configure() {
	local libdir=$(get_libdir)
	local mycmakeargs=(
		-DLLVM_CONFIG=OFF
		-DLIBCXXABI_BUILT_STANDALONE=ON
		-DLIBCXXABI_LIBDIR_SUFFIX=${libdir#lib}
		-DLIBCXXABI_ENABLE_STATIC=$(usex static-libs)
		-DLIBCXXABI_LIBCXX_INCLUDES="${LIBCXX_S}/include"
		-DLIBCXXABI_USE_LLVM_UNWINDER=$(usex libunwind)
		-DLIBCXXABI_LIBUNWIND_INCLUDES="${EPREFIX}/usr/include/libunwind"
	)

	cmake-utils_src_configure
}

multilib_src_install_all() {
	insinto "/usr/include/${PN}/"
	doins include/*
}
