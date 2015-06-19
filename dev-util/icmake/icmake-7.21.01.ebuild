# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/icmake/icmake-7.21.01.ebuild,v 1.1 2014/01/23 00:49:27 radhermit Exp $

EAPI=5

inherit multilib toolchain-funcs eutils

DESCRIPTION="Hybrid between a make utility and a shell scripting language"
HOMEPAGE="http://icmake.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P/-/_}.orig.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	sed -e "/^#define LIBDIR/s/lib/$(get_libdir)/" \
		-e "/^#define DOCDIR/s/${PN}/${PF}/" \
		-e "/^#define DOCDOCDIR/s/${PN}-doc/${PF}/" \
		-i INSTALL.im || die

	epatch "${FILESDIR}"/${PN}-7.20.00-ar.patch
	tc-export AR CC
}

src_compile() {
	./icm_bootstrap "${EROOT}" || die
}

src_install() {
	./icm_install all "${ED}" || die
}
