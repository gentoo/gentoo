# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool multilib-minimal

DESCRIPTION="VBI Decoding Library for Zapping"
HOMEPAGE="https://zapping.sourceforge.net"
SRC_URI="mirror://sourceforge/project/zapping/${PN}/${PV}/${P}.tar.bz2"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86"
IUSE="doc dvb nls v4l X"

RDEPEND=">=media-libs/libpng-1.5.18:0=[${MULTILIB_USEDEP}]
	>=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}]
	nls? ( >=virtual/libintl-0-r1[${MULTILIB_USEDEP}] )
	X? ( >=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	virtual/os-headers
	X? ( x11-libs/libXt )"
BDEPEND="doc? ( app-doc/doxygen )
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}"/tests-gcc7.patch
)

src_prepare() {
	default
	elibtoolize
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable v4l) \
		$(use_enable dvb) \
		$(use_enable nls) \
		$(use_with X x) \
		$(multilib_native_use_with doc doxygen)
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	if multilib_is_native_abi; then
		if use doc; then
			docinto html
			dodoc doc/html/*.{png,gif,html,css}
		fi
	fi
}

multilib_src_install_all() {
	# This may have been left pointing to "html"
	docinto
	dodoc AUTHORS BUGS ChangeLog NEWS README TODO

	find "${ED}" -name '*.la' -delete
}
