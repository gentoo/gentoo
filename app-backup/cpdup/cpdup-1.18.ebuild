# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils toolchain-funcs

DESCRIPTION="A comprehensive filesystem mirroring program"
HOMEPAGE="http://apollo.backplane.com/FreeSrc/"
SRC_URI="http://apollo.backplane.com/FreeSrc/${P}.tgz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~x86-fbsd ~amd64"
IUSE="userland_GNU threads"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}"/${PN}-1.11-unused.patch

	if use userland_GNU; then
		cp "${FILESDIR}"/Makefile.linux Makefile
		# bits/stat.h has __unused too
		sed -i 's/__unused/__cpdup_unused/' *.c
		echo "#define strlcpy(a,b,c) strncpy(a,b,c)" >> cpdup.h
	fi
}

src_compile() {
	tc-export CC
	use threads || MAKEOPTS="$MAKEOPTS NOPTHREADS=1"
	MAKE=make emake || die "emake failed"
}

src_install() {
	dobin cpdup || die "cannot install cpdup"
	doman cpdup.1
	docinto scripts
	dodoc scripts/*
}
