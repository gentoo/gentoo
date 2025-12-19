# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal autotools

DESCRIPTION="a configuration file parser library"
HOMEPAGE="https://github.com/libconfuse/libconfuse"
SRC_URI="https://github.com/libconfuse/libconfuse/releases/download/v${PV}/${P}.tar.xz"

LICENSE="ISC"
SLOT="0/2.1.0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"

IUSE="nls static-libs"

BDEPEND="
	app-alternatives/lex
	dev-build/libtool
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"
RDEPEND="
	nls? ( virtual/libintl[${MULTILIB_USEDEP}] )
"

PATCHES=(
	# Upstream commit to fix CVE-2022-40320:
	# https://github.com/libconfuse/libconfuse/commit/d73777c2c3566fb2647727bb56d9a2295b81669b
	"${FILESDIR}"/confuse-3.3-fix-CVE-2022-40320.patch
	# https://github.com/libconfuse/libconfuse/pull/167
	"${FILESDIR}"/confuse-3.3-lfs.patch
	# https://github.com/libconfuse/libconfuse/pull/181
	"${FILESDIR}"/confuse-3.3-isspace.patch
)

DOCS=( AUTHORS )

src_prepare() {
	default
	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	# examples are normally compiled but not installed. They
	# fail during a mingw crosscompile.
	local ECONF_SOURCE=${BUILD_DIR}
	econf \
		--disable-examples \
		$(use_enable nls) \
		$(use_enable static-libs static)
}

multilib_src_install_all() {
	doman doc/man/man3/*.3
	dodoc -r doc/html

	docinto examples
	dodoc examples/*.{c,conf}

	find "${D}" -name '*.la' -type f -delete || die
}
