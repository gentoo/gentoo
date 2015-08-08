# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs eutils flag-o-matic

DESCRIPTION="Info ZIP (encryption support)"
HOMEPAGE="http://www.info-zip.org/"
SRC_URI="ftp://ftp.info-zip.org/pub/infozip/src/zip${PV//.}.tar.gz"

LICENSE="Info-ZIP"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="crypt"

DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/zip-2.3-unix_configure-pic.patch
	epatch "${FILESDIR}"/${PN}-2.31-exec-stack.patch
	epatch "${FILESDIR}"/${PN}-2.32-build.patch
}

src_compile() {
	tc-export CC CPP
	use crypt || append-flags -DNO_CRYPT
	append-lfs-flags
	emake -f unix/Makefile generic || die
}

src_install() {
	dobin zip zipnote zipsplit || die
	doman man/zip.1
	dosym zip.1 /usr/share/man/man1/zipnote.1
	dosym zip.1 /usr/share/man/man1/zipsplit.1
	if use crypt ; then
		dobin zipcloak || die
		dosym zip.1 /usr/share/man/man1/zipcloak.1
	fi
	dodoc BUGS CHANGES MANUAL README TODO WHATSNEW WHERE proginfo/*.txt
}
