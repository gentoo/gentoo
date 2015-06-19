# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/htun/htun-0.9.6.ebuild,v 1.1 2013/03/12 04:35:43 pinkbyte Exp $

EAPI="5"

inherit eutils readme.gentoo

DESCRIPTION="Project to tunnel IP traffic over HTTP"
HOMEPAGE="http://linux.softpedia.com/get/System/Networking/HTun-14751.shtml"
SRC_URI="http://www.sourcefiles.org/Networking/Tools/Proxy/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

# should not be replaced by virtual/yacc
# at least failed with dev-util/bison
DEPEND="dev-util/yacc"
RDEPEND=""

src_prepare() {
	epatch "${FILESDIR}"/${P}-glibc.patch #248100
	epatch "${FILESDIR}"/${P}-makefile.patch

	epatch_user
}

src_compile() {
	emake -C src CC="$(tc-getCC)"
}

src_install() {
	dosbin src/htund
	insinto /etc
	doins doc/htund.conf
	dodoc doc/* README
	readme.gentoo_create_doc
}
