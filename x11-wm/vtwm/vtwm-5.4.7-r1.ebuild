# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils toolchain-funcs

DESCRIPTION="one of many TWM descendants and implements a Virtual Desktop"
HOMEPAGE="http://www.vtwm.org/"
SRC_URI="http://www.vtwm.org/downloads/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~ppc ~sparc ~x86"
IUSE="rplay"

RDEPEND="x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXext
	x11-libs/libXpm
	rplay? ( media-sound/rplay )"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex
	x11-misc/imake
	app-text/rman
	x11-proto/xproto
	x11-proto/xextproto"

src_prepare() {
	epatch "${FILESDIR}"/${P}-do-not-rm.patch
	sed -i Imakefile \
		-e 's:-L/usr/local/lib::g' \
		-e 's:-I/usr/local/include::g' \
		|| die "sed Imakefile"
	if ! use rplay ; then
		sed -i Imakefile \
			-e 's:^XCOMM\ \(.*NO_SOUND\):\1:' \
			-e 's:^\(SOUNDLIB.*\):XCOMM\ \1:' \
			-e 's:sound\..::g' \
			|| die "sed Imakefile"
		epatch "${FILESDIR}"/${P}-NO_SOUND_SUPPORT.patch
	fi
}

src_configure() {
	xmkmf || die "xmkmf failed"
	emake depend || die "emake depend"
}

src_compile() {
	emake \
		CC=$(tc-getCC) \
		CCOPTIONS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}" \
		|| die "emake failed"
}

src_install() {
	emake BINDIR=/usr/bin \
		LIBDIR=/etc/X11 \
		MANPATH=/usr/share/man \
		DESTDIR="${D}" install || die "emake install failed"

	echo "#!/bin/sh" > vtwm
	echo "xsetroot -cursor_name left_ptr &" >> vtwm
	echo "/usr/bin/vtwm" >> vtwm
	exeinto /etc/X11/Sessions
	doexe vtwm || die
	dodoc doc/{4.7.*,CHANGELOG,BUGS,DEVELOPERS,HISTORY,SOUND,WISHLIST} || die
}
