# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/dvd+rw-tools/dvd+rw-tools-7.1.ebuild,v 1.12 2008/10/27 05:42:13 vapier Exp $

inherit eutils toolchain-funcs

DESCRIPTION="A set of tools for DVD+RW/-RW drives"
HOMEPAGE="http://fy.chalmers.se/~appro/linux/DVD+RW/"
SRC_URI="http://fy.chalmers.se/~appro/linux/DVD+RW/tools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sh sparc x86"
IUSE=""

RDEPEND="virtual/cdrtools"
DEPEND="${RDEPEND}
	sys-devel/m4"

src_unpack() {
	unpack ${A}
	cd "${S}"
	# Linux compiler flags only include -O2 and are incremental
	sed -i '/FLAGS/s:-O2::' Makefile.m4
}

src_compile() {
	emake SHELL=/bin/bash CC=$(tc-getCC) CXX=$(tc-getCXX) || die
}

src_install() {
	emake SHELL=/bin/bash prefix="${D}/usr" install || die
	dohtml index.html
}

pkg_postinst() {
	elog "When you run growisofs if you receive:"
	elog "unable to anonymously mmap 33554432: Resource temporarily unavailable"
	elog "error message please run 'ulimit -l unlimited'"
}
