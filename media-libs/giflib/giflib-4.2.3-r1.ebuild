# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools-multilib eutils

DESCRIPTION="Library to handle, display and manipulate GIF images"
HOMEPAGE="http://sourceforge.net/projects/giflib/"
SRC_URI="mirror://sourceforge/giflib/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs X"

RDEPEND="X? ( >=x11-libs/libX11-1.6.2[${MULTILIB_USEDEP}] )
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20140406-r1
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32]
	)"
DEPEND="${RDEPEND}"

src_prepare() {
	# don't generate html docs
	sed -i '/^SUBDIRS/s/doc//' Makefile.am || die

	epatch "${FILESDIR}"/${PN}-4.1.6-giffix-null-Extension-fix.patch
	sed -i \
		-e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' \
		-e 's:${X_PRE_LIBS}::' \
		configure.ac || die #486542,#483258
	eautoreconf

	sed -i '/X_PRE_LIBS/s:-lSM -lICE::' configure || die #483258
}

src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		$(use_enable X x11)
		)
	autotools-multilib_src_configure
}

src_test() {
	autotools-multilib_src_test -C tests
}

src_install() {
	autotools-multilib_src_install

	# for static libs the .la file is required if built with +X
	use static-libs || prune_libtool_files --all

	doman doc/*.1
	dodoc doc/*.txt
}
