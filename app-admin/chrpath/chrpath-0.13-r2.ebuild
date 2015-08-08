# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit eutils autotools

DESCRIPTION="chrpath can modify the rpath and runpath of ELF executables"
HOMEPAGE="http://directory.fsf.org/project/chrpath/"
# original upstream no longer exists (ftp://ftp.hungry.com/pub/hungry)
SRC_URI="http://ftp.tux.org/pub/X-Windows/ftp.hungry.com/chrpath/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ~mips ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

src_prepare() {
	epatch "${FILESDIR}"/${P}-multilib.patch
	epatch "${FILESDIR}"/${PN}-keepgoing.patch
	epatch "${FILESDIR}"/${P}-testsuite-1.patch
	# disable installing redundant docs in the wrong dir
	sed -i -e '/doc_DATA/d' Makefile.am || die
	# fix for automake-1.13, #467538
	sed -i -e 's/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/' configure.ac || die
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static) || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc ChangeLog AUTHORS NEWS README
	use static-libs || find "${D}" -name "*.la" -exec rm '{}' +
}
