# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3
inherit eutils toolchain-funcs

IUSE=""
DESCRIPTION="Clock applet for AfterStep"
SRC_URI="http://www.tigr.net/afterstep/download/asclock/${P}.tar.gz"
HOMEPAGE="http://tigr.net/afterstep/applets/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ppc sparc x86 ~amd64-linux ~x86-linux ~x64-solaris"

DEPEND="x11-libs/libXpm"
RDEPEND="${DEPEND}
	x11-proto/xextproto
	x11-proto/xproto"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-gcc41.patch
	ln -s themes/classic default_theme
}

src_configure() { :; }

src_compile() {
	local x
	# will break Solaris
	[[ ${CHOST} == *-linux-gnu ]] && CFLAGS="${CFLAGS} \
		-Dlinux \
		-D_POSIX_C_SOURCE=199309L \
		-D_POSIX_SOURCE \
		-D_XOPEN_SOURCE"
	for x in asclock parser symbols config
	do
		$(tc-getCC) \
			${CPPFLAGS} ${CFLAGS} ${ASFLAGS} \
			-I"${EPREFIX}"/usr/include \
			-D_BSD_SOURCE \
			-D_SVID_SOURCE \
			-DFUNCPROTO=15 \
			-DNARROWPROTO \
			-c -o ${x}.o ${x}.c || die "compile asclock failed"
	done
	$(tc-getCC) \
		${LDFLAGS} \
		-o asclock \
		asclock.o parser.o symbols.o config.o \
		-L"${EPREFIX}"/usr/lib \
		-L"${EPREFIX}"/usr/lib/X11 \
		-lXpm -lXext -lX11 || die "link asclock failed"
}

src_install() {
	dobin asclock
	local themesdir="/usr/share/${PN}/themes"
	insinto ${themesdir}
	doins -r themes/*
	dodoc README README.THEMES TODO
	cd "${D}"/${themesdir}
	rm -f Freeamp/Makefile{,.*}
	ln -s classic default_theme
}
