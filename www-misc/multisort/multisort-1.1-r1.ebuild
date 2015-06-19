# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-misc/multisort/multisort-1.1-r1.ebuild,v 1.1 2012/11/30 18:23:37 pinkbyte Exp $

EAPI=4

inherit toolchain-funcs

DESCRIPTION="multisort takes any number of httpd logfiles in the Common Log Format and merges them together"
HOMEPAGE="http://www.xach.com/multisort/"
SRC_URI="http://www.xach.com/${PN}/${PN}-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""

src_prepare() {
	# respect LDFLAGS wrt bug #337359
	sed -i -e 's/$(CFLAGS)/& \$(LDFLAGS)/' Makefile || die 'sed on Makefile failed'
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_install() {
	dosbin multisort
}
