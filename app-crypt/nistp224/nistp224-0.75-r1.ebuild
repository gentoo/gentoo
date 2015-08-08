# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils toolchain-funcs flag-o-matic fixheadtails

DESCRIPTION="nistp224 performs compressed Diffie-Hellman key exchange on the NIST P-224 elliptic curve"
HOMEPAGE="http://cr.yp.to/nistp224.html"
SRC_URI="http://cr.yp.to/${PN}/${P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
RESTRICT="mirror bindist"

DEPEND=""
RDEPEND=${DEPEND}
S="${WORKDIR}/math/${P}/src"

src_prepare() {
	epatch "${FILESDIR}"/${P}-asmfix.patch
	epatch "${FILESDIR}"/${P}-declare-exit.patch
	cd "${S}"
	epatch "${FILESDIR}"/${P}-honour-CC.patch
	ht_fix_file Makefile print*.sh
}

src_configure() {
	append-flags -fPIC
	echo -n "$(tc-getCC) ${CFLAGS}" > conf-cc
	echo -n "$(tc-getCC) ${LDFLAGS}" > conf-ld
	if use ppc; then
		# untested
		echo -n "powerpc" > conf-opt
	elif use sparc; then
		# untested
		echo -n "sparc" > conf-opt
	else
		# optiminations for ppro and pentium fail
		echo -n "idea64" > conf-opt
	fi
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dobin nistp224 nistp224-56
	mv nistp224.a libnistp224.a
	dolib.a libnistp224.a
	insinto /usr/include
	doins nistp224.h
}
