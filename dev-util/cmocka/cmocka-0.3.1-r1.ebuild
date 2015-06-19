# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cmocka/cmocka-0.3.1-r1.ebuild,v 1.3 2014/08/04 16:06:13 klausman Exp $

EAPI=5

inherit cmake-multilib

DESCRIPTION="A unit testing framework for C"
HOMEPAGE="http://cmocka.org/"
SRC_URI="https://open.cryptomilk.org/attachments/download/19/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~s390 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="doc static-libs test"

DEPEND="
	doc? ( app-doc/doxygen[latex] )
"
RDEPEND=""

PATCHES=( "${FILESDIR}/${PN}-automagicness.patch" )

multilib_src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with static-libs STATIC_LIB)
		$(cmake-utils_use test UNIT_TESTING)
		$(multilib_is_native_abi && cmake-utils_use_with doc APIDOC \
			|| echo -DWITH_APIDOC=OFF)
	)
	cmake-utils_src_configure
}

multilib_src_install() {
	if multilib_is_native_abi && use doc; then
		pushd doc || die
		doxygen doxy.config || die
		rm -f html/*.md5 latex/*.md5 latex/Manifest man/man3/_* || die
		dohtml html/*
		dodoc latex/*
		doman man/man3/*.3
		popd || die
	fi
	cmake-utils_src_install
}
