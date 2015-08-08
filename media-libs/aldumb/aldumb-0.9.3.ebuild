# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils

DESCRIPTION="Allegro support for DUMB (an IT, XM, S3M, and MOD player library)"
HOMEPAGE="http://dumb.sourceforge.net/"
SRC_URI="mirror://sourceforge/dumb/dumb-${PV}.tar.gz"

LICENSE="DUMB-0.9.2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug"

DEPEND=">=media-libs/dumb-0.9.3
	<media-libs/allegro-5"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${P/aldumb/dumb}"

src_prepare() {
	cat << EOF > make/config.txt
include make/unix.inc
ALL_TARGETS := allegro allegro-examples allegro-headers
PREFIX := /usr
EOF
	epatch "${FILESDIR}"/${P}-PIC-as-needed.patch
	epatch "${FILESDIR}"/${P}_CVE-2006-3668.patch
	sed -i '/= -s/d' Makefile || die "sed failed"
	cp -f Makefile Makefile.rdy
}

src_compile() {
	emake OFLAGS="${CFLAGS}" all || die "emake failed"
}

src_install() {
	dobin examples/dumbplay
	dolib.so lib/unix/libaldmb.so

	use debug && lib/unix/libaldmd.so

	insinto /usr/include
	doins include/aldumb.h
}
