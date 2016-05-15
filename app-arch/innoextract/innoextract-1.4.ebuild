# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs cmake-utils

DESCRIPTION="A tool to unpack installers created by Inno Setup"
HOMEPAGE="http://innoextract.constexpr.org/"
SRC_URI="mirror://github/dscharrer/InnoExtract/${P}.tar.gz
	mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="c++0x debug doc +lzma static"

RDEPEND="
	!static? (
		dev-libs/boost
		virtual/libiconv
		lzma? ( app-arch/xz-utils )
	)"
DEPEND="${RDEPEND}
	doc? ( >=app-doc/doxygen-1.8.3.1 )
	static? (
		app-arch/bzip2[static-libs]
		dev-libs/boost[static-libs]
		sys-libs/zlib[static-libs]
		virtual/libiconv
		lzma? ( app-arch/xz-utils[static-libs] )
	)"

DOCS=( README.md CHANGELOG )

PATCHES=(
	"${FILESDIR}"/${P}-cmake.patch
	"${FILESDIR}"/${P}-cmake-3.5.patch
)

pkg_pretend() {
	if [[ ${MERGE_TYPE} != binary ]]; then
		# not sure about minimum clang req
		if use c++0x && [[ $(tc-getCXX) == *g++ && $(tc-getCXX) != *clang++ ]] ; then
			if [[ $(gcc-major-version) == 4 && $(gcc-minor-version) -lt 7 || $(gcc-major-version) -lt 4 ]] ; then
				eerror "You need at least sys-devel/gcc-4.7.0 for C++0x capabilities"
				die "You need at least sys-devel/gcc-4.7.0 for C++0x capabilities"
			fi
		fi
	fi
}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_use lzma LZMA)
		$(cmake-utils_use_use static STATIC_LIBS)
		$(cmake-utils_use_use c++0x CXX11)
		$(cmake-utils_use_with debug DEBUG)
		-DSET_OPTIMIZATION_FLAGS=OFF
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
	use doc && cmake-utils_src_compile doc
}

src_install() {
	cmake-utils_src_install
	use doc && dohtml -r "${CMAKE_BUILD_DIR}"/doc/html/*
}
