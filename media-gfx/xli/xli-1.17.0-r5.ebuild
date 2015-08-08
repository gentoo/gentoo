# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils

SNAPSHOT="2005-02-27"
DESCRIPTION="X Load Image: view images or load them to root window"
HOMEPAGE="ftp://ftp.ibiblio.org/pub/Linux/apps/graphics/viewers/X/xli-1.16.README"
SRC_URI="http://pantransit.reptiles.org/prog/xli/xli-${SNAPSHOT}.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

RDEPEND="app-arch/bzip2
	>=media-libs/libpng-1.0.5
	>=sys-libs/zlib-1.1.4
	virtual/jpeg:0
	x11-libs/libXext"

DEPEND="${RDEPEND}
	app-text/rman
	x11-proto/xextproto
	x11-misc/imake
	!media-gfx/xloadimage"

S=${WORKDIR}/${PN}-${SNAPSHOT}

src_prepare() {
	# avoid conflicts on systems that have zopen in system headers
	sed -i -e "s:zopen:xli_zopen:g" *

	sed -i Imakefile \
		-e '/^DEFINES =/s/$/ -DHAVE_GUNZIP -DHAVE_BUNZIP2 /' \
		-e '/CCOPTIONS =/s/=.*/=/'

	# This is a hack to avoid a parse error on /usr/include/string.h
	# when _BSD_SOURCE is defined. This may be a bug in that header.
	sed	-i png.c \
		-e '/^#include "xli.h"/i#undef _BSD_SOURCE'

	# This hack will allow xli to compile using gcc-3.3
	sed -i rlelib.c \
		-e 's/#include <varargs.h>//'

	# fix potential security issues.
	EPATCH_OPTS="-F3 -l" epatch "${FILESDIR}"/xli-security-gentoo.diff

	# Fix scale per bug 282979
	epatch "${FILESDIR}"/${P}-fix-scale-zoom.patch \
		"${FILESDIR}"/${P}-libpng14.patch
}

src_compile() {
	xmkmf || die
	emake CDEBUGFLAGS="${CFLAGS}" CC="$(tc-getCC)" EXTRA_LDOPTIONS="${LDFLAGS}"
}

src_install() {
	dobin xli xlito

	dosym xli /usr/bin/xsetbg
	dosym xli /usr/bin/xview

	dodoc README README.xloadimage ABOUTGAMMA TODO chkgamma.jpg
	newman xli.man xli.1
	newman xliguide.man xliguide.1
	newman xlito.man xlito.1

	insinto /etc/X11/app-defaults
	newins "${FILESDIR}"/Xli.ad Xli
	fperms a+r /etc/X11/app-defaults/Xli
}
