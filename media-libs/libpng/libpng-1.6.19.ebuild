# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils libtool multilib-minimal

DESCRIPTION="Portable Network Graphics library"
HOMEPAGE="http://www.libpng.org/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz
	apng? ( mirror://sourceforge/apng/${P}-apng.patch.gz )"

LICENSE="libpng"
SLOT="0/16"
KEYWORDS="alpha amd64 ~arm ~arm64 hppa ia64 ~m68k ~mips ~ppc ppc64 ~s390 ~sh ~sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris ~x86-winnt"
IUSE="apng neon static-libs"

RDEPEND=">=sys-libs/zlib-1.2.8-r1:=[${MULTILIB_USEDEP}]
	abi_x86_32? ( !<=app-emulation/emul-linux-x86-baselibs-20130224-r1
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)] )"
DEPEND="${RDEPEND}
	app-arch/xz-utils"

src_prepare() {
	if use apng; then
		epatch "${WORKDIR}"/${PN}-*-apng.patch
		# Don't execute symbols check with apng patch wrt #378111
		sed -i -e '/^check/s:scripts/symbols.chk::' Makefile.in || die
	fi
	elibtoolize
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable static-libs static) \
		--enable-arm-neon=$(usex neon)
}

multilib_src_install_all() {
	dodoc ANNOUNCE CHANGES libpng-manual.txt README TODO
	prune_libtool_files --all
}
