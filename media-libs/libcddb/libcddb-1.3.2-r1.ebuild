# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="A library for accessing a CDDB server"
HOMEPAGE="http://libcddb.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="doc static-libs"

RDEPEND=">=virtual/libiconv-0-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="doc? ( app-doc/doxygen )"

RESTRICT="test"

DOCS=( AUTHORS ChangeLog NEWS README THANKS TODO )

MULTILIB_WRAPPED_HEADERS=( /usr/include/cddb/version.h )

src_prepare() {
	default
	# Required for CONFIG_SHELL != bash (bug #528012)
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		--without-cdio
		$(use_enable static-libs static)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	default

	if use doc ; then
		cd "${S}"/doc || die
		doxygen doxygen.conf || die
	fi
}

multilib_src_install_all() {
	default

	find "${ED}" -type f -name "*.la" -delete || die

	if use doc ; then
		docinto html
		dodoc "${S}"/doc/html/*
	fi
}
