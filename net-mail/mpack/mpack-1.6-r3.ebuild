# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/mpack/mpack-1.6-r3.ebuild,v 1.5 2014/04/19 10:10:29 eras Exp $

EAPI="3"

AT_M4DIR=cmulocal

inherit eutils autotools

DESCRIPTION="Command-line MIME encoding and decoding utilities"
HOMEPAGE="ftp://ftp.andrew.cmu.edu/pub/mpack/"
SRC_URI="ftp://ftp.andrew.cmu.edu/pub/mpack/${P}.tar.gz"

SLOT="0"
LICENSE="HPND"
KEYWORDS="amd64 x86 ~ppc-macos ~sparc-solaris ~x86-solaris"
IUSE=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-filenames.patch
	epatch "${FILESDIR}"/${P}-usage.patch
	epatch "${FILESDIR}"/${P}-munpack.patch

	# NOTE: These three patches replace <mpack-1.6-gentoo.patch>
	epatch "${FILESDIR}"/${P}-compile.patch
	epatch "${FILESDIR}"/${P}-paths.patch
	epatch "${FILESDIR}"/${P}-cve-2011-4919.patch

	epatch "${FILESDIR}"/${P}-clang.patch

	eautoreconf
}

src_install () {
	emake DESTDIR="${D}" install || die
	dodoc README.* Changes
}
