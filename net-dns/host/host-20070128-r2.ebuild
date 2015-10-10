# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs multilib

DESCRIPTION="A powerful command-line DNS query and test tool implementing many additional protocols"
HOMEPAGE="http://www.weird.com/~woods/projects/host.html"
SRC_URI="ftp://ftp.weird.com/pub/Planix/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
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
	emake CC="$(tc-getCC)" RES_LIB=/usr/$(get_libdir)/libresolv.a
}

src_install () {
	# This tool has slightly different format of output from "standard" host.
	# Renaming it to host-woods, hopefully this does not conflict with anything.

	newbin host host-woods
	newman host.1 host-woods.1
	dodoc RELEASE_NOTES ToDo
}
