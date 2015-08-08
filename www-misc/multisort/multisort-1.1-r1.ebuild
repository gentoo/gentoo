# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
