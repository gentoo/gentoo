# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/ssvnc/ssvnc-1.0.28.ebuild,v 1.6 2011/12/14 09:21:02 phajdan.jr Exp $

EAPI="3"
inherit eutils multilib toolchain-funcs

DESCRIPTION="VNC viewer that adds encryption security to VNC connections"
HOMEPAGE="http://www.karlrunge.com/x11vnc/ssvnc.html"
SRC_URI="mirror://sourceforge/ssvnc/${P}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-linux"
IUSE="java"

RDEPEND="sys-libs/zlib
	virtual/jpeg
	dev-libs/openssl
	dev-lang/tk
	net-misc/stunnel
	java? ( virtual/jre )
	x11-terms/xterm
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXaw
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXp
	x11-libs/libXpm
	x11-libs/libXt"
DEPEND="${RDEPEND}
	java? ( virtual/jdk )"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.0.27-build.patch

	sed -i \
		-e "/^LIB/s:lib/:$(get_libdir)/:" \
		-e "$(use java || echo '/^JSRC/s:=.*:=:')" \
		Makefile
	sed -i \
		-e '/^CC/s:=.*:+= $(CFLAGS) $(CPPFLAGS) $(LDFLAGS):' \
		vncstorepw/Makefile

	cp "${FILESDIR}"/Makefile.libvncauth vnc_unixsrc/libvncauth/Makefile
	cd "${S}"/vnc_unixsrc/vncviewer
	sed -n '/^SRCS/,/^$/p' Imakefile > Makefile.in
	cp "${FILESDIR}"/Makefile.vncviewer Makefile
}

src_compile() {
	tc-export AR CC CXX RANLIB
	emake all || die
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install || \
		die "make install failed"
	dodoc README
}
