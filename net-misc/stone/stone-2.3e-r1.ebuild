# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="A simple TCP/IP packet repeater"
HOMEPAGE="http://www.gcd.org/sengoku/stone/"
SRC_URI="http://www.gcd.org/sengoku/stone/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"
IUSE="ssl"

DEPEND="ssl? ( dev-libs/openssl )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-2.3d-2.3.2.7"

PATCHES=( "${FILESDIR}/${P}-makefile.patch" ) # bug #337879

src_prepare() {
	tc-export CC
	append-cflags "-D_GNU_SOURCE"

	epatch ${PATCHES[@]}
	epatch_user
}

src_compile() {
	local myargs
	if use ssl ; then
		myargs="SSL=/usr linux-ssl"
	else
		myargs="linux"
	fi
	emake ${myargs}
}

src_install() {
	dobin stone
	newman "${FILESDIR}/${PN}.man" "${PN}.1"
	dodoc README*
}
