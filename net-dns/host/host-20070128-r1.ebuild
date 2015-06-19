# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/host/host-20070128-r1.ebuild,v 1.11 2013/04/14 18:06:00 ulm Exp $

EAPI="2"
inherit eutils toolchain-funcs multilib

DESCRIPTION="A powerful command-line DNS query and test tool implementing many additional protocols"
HOMEPAGE="http://www.weird.com/~woods/projects/host.html"
SRC_URI="ftp://ftp.weird.com/pub/Planix/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ~mips ppc ppc64 sparc x86"
IUSE="debug"

# Bug 91515
RESTRICT="test"

RDEPEND=""
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_prepare() {
	epatch "${FILESDIR}/${P}-Makefile.patch"
	sed -i  -e "s:^\(# if defined(__alpha).*\):\1 || defined(__x86_64__):" \
		port.h || die "sed failed"
}

src_compile() {
	use debug && export DEBUGDEFS="-DDEBUG"
	emake CC="$(tc-getCC)" RES_LIB=/usr/$(get_libdir)/libresolv.a || die "emake failed"
}

src_install () {
	# This tool has slightly different format of output from "standard" host.
	# Renaming it to host-woods, hopefully this does not conflict with anything.

	newbin host host-woods || die "newbin failed"
	newman host.1 host-woods.1 || die "newman failed"
	dodoc RELEASE_NOTES ToDo || die "dodoc failed"
}
