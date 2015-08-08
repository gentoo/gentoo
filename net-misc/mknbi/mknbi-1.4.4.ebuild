# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs eutils

DESCRIPTION="Utility for making tagged kernel images useful for netbooting"
SRC_URI="mirror://sourceforge/etherboot/${P}.tar.gz"
RESTRICT="mirror"
HOMEPAGE="http://etherboot.sourceforge.net"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86"
IUSE=""

RDEPEND=">=dev-lang/perl-5.6.1
	!sys-boot/netboot"
DEPEND="${RDEPEND}
	dev-lang/nasm"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch \
		"${FILESDIR}"/mknbi-1.4.3-nossp.patch \
		"${FILESDIR}"/${P}-gcc4.patch

	sed -i \
		-e "s:\/usr\/local:\/usr:" \
		-e "s:COPYING::" \
		-e "s:\-mcpu:\-march:" Makefile \
		|| die "sed failed"
	sed -r /^DOCDIR/s:packages/.*:${PF}: -i Makefile || die "sed failed"

	#apply modifications to CFLAGS to fix for gcc 3.4: bug #64049
	if [ "`gcc-major-version`" -ge "3" -a "`gcc-minor-version`" -ge "4" ]
	then
		sed -i \
			-e 's:\-mcpu:\-mtune:' \
			-e 's:CFLAGS=:CFLAGS= -minline-all-stringops:' Makefile \
			|| die "sed failed"
	fi
	if [ "`gcc-major-version`" = "4" ]; then
		sed -i \
			-e 's:\-fno-stack-protector-all::' Makefile \
			|| die "sed failed"
	fi
}

src_install() {
	export BUILD_ROOT="${D}"
	emake DESTDIR="${D}" install || die "emake failed"
	prepalldocs
}
