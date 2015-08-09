# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs multilib-build multilib-minimal

DESCRIPTION="IT/XM/S3M/MOD player library with click removal and IT filters"
HOMEPAGE="http://dumb.sourceforge.net/"
SRC_URI="mirror://sourceforge/dumb/${P}.tar.gz"

LICENSE="DUMB-0.9.2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE="debug"

RDEPEND=""
DEPEND=""

src_prepare() {
	cat << EOF > make/config.txt
include make/unix.inc
ALL_TARGETS := core core-examples core-headers
PREFIX := /usr
EOF

	epatch "${FILESDIR}"/${P}-PIC-as-needed.patch
	epatch "${FILESDIR}"/${P}_CVE-2006-3668.patch
	sed -i '/= -s/d' Makefile || die "sed failed"
	cp -f Makefile Makefile.rdy

	multilib_copy_sources
}

multilib_src_compile() {
	emake CC="$(tc-getCC)" OFLAGS="${CFLAGS}" all
}

multilib_src_install() {
	dolib.so lib/unix/libdumb.so
	use debug && dolib.so lib/unix/libdumbd.so

	doheader include/dumb.h

	dobin examples/{dumbout,dumb2wav}
	dodoc readme.txt release.txt docs/*
}

pkg_postinst() {
	elog "DUMB's core has been installed. This will enable you to convert module"
	elog "files to PCM data (ready for sending to /dev/dsp, writing to a .wav"
	elog "file, piping through oggenc, etc.)."
	elog
	elog "If you are using Allegro, you will also want to 'emerge aldumb'. This"
	elog "provides you with a convenient API for playing module files through"
	elog "Allegro's sound system, and also enables DUMB to integrate with"
	elog "Allegro's datafile system so you can add modules to datafiles."
	elog
	elog "As a developer, when you distribute your game and write your docs, be"
	elog "aware that 'dumb' and 'aldumb' actually come from the same download."
	elog "People who don't use Gentoo will only have to download and install one"
	elog "package. See readme.txt in /usr/share/doc/${PF} for details on"
	elog "how DUMB would be compiled manually."
}
