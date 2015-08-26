# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-multilib eutils toolchain-funcs

MY_P="${P/_/}"
S="${WORKDIR}/${PN}-1.4.0"

DESCRIPTION="A ASCII-Graphics Library"
HOMEPAGE="http://aa-project.sourceforge.net/aalib/"
SRC_URI="mirror://sourceforge/aa-project/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE="X slang gpm static-libs"

RDEPEND="
	X? ( >=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}] )
	gpm? ( >=sys-libs/gpm-1.20.7-r2[${MULTILIB_USEDEP}] )
	slang? ( >=sys-libs/slang-2.2.4-r1[${MULTILIB_USEDEP}] )
	>=sys-libs/ncurses-5.9-r3:0=[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	X? ( x11-proto/xproto )
"

DOCS="ANNOUNCE AUTHORS ChangeLog NEWS README*"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.4_rc4-gentoo.patch
	epatch "${FILESDIR}"/${PN}-1.4_rc4-m4.patch
	epatch "${FILESDIR}"/${PN}-1.4_rc5-fix-protos.patch #224267
	epatch "${FILESDIR}"/${PN}-1.4_rc5-fix-aarender.patch #214142
	epatch "${FILESDIR}"/${PN}-1.4_rc5-tinfo.patch #468566

	sed -i -e 's:#include <malloc.h>:#include <stdlib.h>:g' "${S}"/src/*.c

	# Fix bug #165617.
	use gpm || sed -i \
		's/gpm_mousedriver_test=yes/gpm_mousedriver_test=no/' "${S}/configure.in"

	#467988 automake-1.13
	mv configure.{in,ac} || die
	sed -i 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g' configure.ac || die

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_with slang slang-driver)
		$(use_with X x11-driver)
		$(use_enable static-libs static)
	)

	PKG_CONFIG=$(tc-getPKG_CONFIG) \
	autotools-multilib_src_configure
}

src_install() {
	autotools-multilib_src_install
	use static-libs || prune_libtool_files --all
}
