# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils multilib toolchain-funcs

DESCRIPTION="VNC viewer that adds encryption security to VNC connections"
HOMEPAGE="http://www.karlrunge.com/x11vnc/ssvnc.html"
SRC_URI="mirror://sourceforge/ssvnc/${P}.src.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~arm-linux ~x86-linux"
IUSE="java"

RDEPEND="sys-libs/zlib
	virtual/jpeg:0
	dev-libs/openssl:0=
	dev-lang/tk:0
	net-misc/stunnel
	java? ( virtual/jre:* )
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

PATCHES=( "${FILESDIR}"/${PN}-1.0.29-build.patch )

src_prepare() {
	default

	sed -i \
		-e "/^LIB/s:lib/:$(get_libdir)/:" \
		-e "$(use java || echo '/^JSRC/s:=.*:=:')" \
		Makefile || die
	sed -i \
		-e '/^CC/s:=.*:+= $(CFLAGS) $(CPPFLAGS) $(LDFLAGS):' \
		vncstorepw/Makefile || die

	cp "${FILESDIR}"/Makefile.libvncauth vnc_unixsrc/libvncauth/Makefile || die
	cd "${S}"/vnc_unixsrc/vncviewer || die
	sed -n '/^SRCS/,/^$/p' Imakefile > Makefile.in || die
	cp "${FILESDIR}"/Makefile.vncviewer Makefile || die
}

src_compile() {
	tc-export AR CC CXX RANLIB
	emake all
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	dodoc README
}
