# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit multilib-minimal

DESCRIPTION="a configuration file parser library"
HOMEPAGE="https://github.com/martinh/libconfuse"
SRC_URI="https://github.com/martinh/libconfuse/releases/download/v${PV}/${P}.tar.xz"

LICENSE="ISC"
SLOT="0/2.0.0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"

IUSE="nls static-libs"

BDEPEND="
	sys-devel/flex
	sys-devel/libtool
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"
RDEPEND="
	nls? ( virtual/libintl[${MULTILIB_USEDEP}] )
"

DOCS=( AUTHORS )

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	# examples are normally compiled but not installed. They
	# fail during a mingw crosscompile.
	local ECONF_SOURCE=${BUILD_DIR}
	econf \
		--enable-shared \
		--disable-examples \
		$(use_enable nls) \
		$(use_enable static-libs static)
}

multilib_src_install_all() {
	doman doc/man/man3/*.3
	dodoc -r doc/html

	docinto examples
	dodoc examples/*.{c,conf}

	find "${D}" -name '*.la' -delete || die
}
