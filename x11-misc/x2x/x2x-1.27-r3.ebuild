# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/x2x/x2x-1.27-r3.ebuild,v 1.9 2014/01/17 14:46:22 jer Exp $

inherit eutils toolchain-funcs

DESCRIPTION="A utility to connect the Mouse and KeyBoard to another X"
HOMEPAGE="http://www.the-labs.com/X11/#x2x"
LICENSE="x2x"
SRC_URI="http://ftp.digital.com/pub/Digital/SRC/x2x/${P}.tar.gz
	mirror://debian/pool/main/x/x2x/x2x_1.27-8.diff.gz
	mirror://gentoo/x2x_1.27-8-initvars.patch.gz
	mirror://gentoo/${P}-license.patch.gz
	mirror://gentoo/${P}-keymap.diff.gz"
SLOT="0"
KEYWORDS="amd64 ~arm ~mips ppc x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXtst
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-proto/inputproto
	app-text/rman
	x11-misc/imake
	x11-proto/xproto"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Patch from Debian to add -north and -south, among other fixes
	epatch "${DISTDIR}"/x2x_1.27-8.diff.gz
	# Revert part of debian patch messing with CFLAGS
	sed -i '/CFLAGS = -Wall/d' Imakefile || die

	# Fix variable initialization in Debian patch
	epatch "${DISTDIR}"/x2x_1.27-8-initvars.patch.gz

	# Patch to add LICENSE
	epatch "${DISTDIR}"/${P}-license.patch.gz

	# Patch to fix bug #126939
	# AltGr does not work in x2x with different keymaps:
	epatch "${DISTDIR}"/${P}-keymap.diff.gz

	# Man-page is packaged as x2x.1 but needs to be x2x.man for building
	mv x2x.1 x2x.man || die
}

src_compile() {
	xmkmf || die
	emake CC="$(tc-getCC)" CDEBUGFLAGS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}" || die
}

src_install () {
	emake DESTDIR="${D}" install || die
	newman x2x.man x2x.1 || die
}
