# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit cmake-multilib

DESCRIPTION="A unit testing framework for C"
HOMEPAGE="https://cmocka.org/"
SRC_URI="https://cmocka.org/files/1.0/${P}.tar.xz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="doc static-libs test"

DEPEND="
	doc? ( app-doc/doxygen[latex] )
"
RDEPEND=""

PATCHES=( "${FILESDIR}/${P}-fix-librt-configure-issue.patch" )

DOCS=( AUTHORS ChangeLog README )

multilib_src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with static-libs STATIC_LIB)
		$(cmake-utils_use test UNIT_TESTING)
		$(multilib_is_native_abi && cmake-utils_use_find_package doc Doxygen \
			|| echo -DCMAKE_DISABLE_FIND_PACKAGE_Doxygen=ON)
	)
	cmake-utils_src_configure
}

multilib_src_install() {
	if multilib_is_native_abi && use doc; then
		pushd doc || die
		doxygen Doxyfile || die
		rm -f html/*.md5 latex/*.md5 latex/Manifest man/man3/_* || die
		dohtml html/*
		dodoc latex/*
		doman man/man3/*.3
		popd || die
	fi
	cmake-utils_src_install
}
