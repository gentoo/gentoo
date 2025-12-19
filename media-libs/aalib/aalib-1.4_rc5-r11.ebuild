# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic multilib-minimal toolchain-funcs

MY_PV="${PV/_/}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="A ASCII-Graphics Library"
HOMEPAGE="https://aa-project.sourceforge.net/aalib/"
SRC_URI="https://download.sourceforge.net/project/aa-project/aa-lib/${MY_PV}/${MY_P}.tar.gz"
S="${WORKDIR}/${PN}-1.4.0"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="X gpm slang"

RDEPEND=">=sys-libs/ncurses-5.9-r3:0=[${MULTILIB_USEDEP}]
	X? ( >=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}] )
	gpm? ( >=sys-libs/gpm-1.20.7-r2[${MULTILIB_USEDEP}] )
	slang? ( >=sys-libs/slang-2.2.4-r1[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4_rc4-gentoo.patch
	"${FILESDIR}"/${PN}-1.4_rc4-m4.patch
	"${FILESDIR}"/${PN}-1.4_rc5-fix-protos.patch #224267
	"${FILESDIR}"/${PN}-1.4_rc5-fix-aarender.patch #214142
	"${FILESDIR}"/${PN}-1.4_rc5-tinfo.patch #468566
	"${FILESDIR}"/${PN}-1.4_rc5-key-down-OOB.patch
	"${FILESDIR}"/${PN}-1.4_rc5-more-protos.patch
	"${FILESDIR}"/${PN}-1.4_rc5-free-offset-pointer.patch #894978
	"${FILESDIR}"/${PN}-1.4_rc5-ncurses-opaque.patch #932140
)

DOCS=( ANNOUNCE AUTHORS ChangeLog NEWS README )

src_prepare() {
	default

	sed -i -e 's:#include <malloc.h>:#include <stdlib.h>:g' "${S}"/src/*.c

	# Fix bug #165617.
	use gpm || sed -i \
		's/gpm_mousedriver_test=yes/gpm_mousedriver_test=no/' "${S}/configure.in"

	#467988 automake-1.13
	mv configure.{in,ac} || die
	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.ac || die

	eautoreconf
}

multilib_src_configure() {
	# Gpm_Wgetch from sys-libs/gpm is unprototyped in gpm.h
	# https://github.com/telmich/gpm/issues/48
	append-cflags -std=gnu17

	ECONF_SOURCE=${S} econf \
		$(use_with slang slang-driver) \
		$(use_with X x11-driver) \
		PKG_CONFIG=$(tc-getPKG_CONFIG)
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	find "${D}" -name '*.la' -type f -delete || die
}
