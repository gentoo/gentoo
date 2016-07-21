# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI=5
inherit eutils

DESCRIPTION="A collection of funny lines from the Linux kernel"
HOMEPAGE="http://www.schwarzvogel.de/software-misc.shtml"
SRC_URI="http://www.schwarzvogel.de/pkgs/kernelcookies-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="offensive"

DEPEND="games-misc/fortune-mod"
RDEPEND="${DEPEND}"

S=${WORKDIR}/kernelcookies-${PV}

src_prepare() {
	# bug #64985
	if ! use offensive ; then
		rm -f *.dat
		epatch "${FILESDIR}"/${PV}-offensive.patch
		strfile -s kernelcookies || die
	fi
}

src_install() {
	insinto /usr/share/fortune
	doins kernelcookies.dat kernelcookies
}
