# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="A flexible logging framework for shell scripts"
HOMEPAGE="http://forestent.com/products/log4sh/"
SRC_URI="http://forestent.com/dist/${PN}/${P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~ppc x86"
IUSE=""

RDEPEND="app-shells/bash"

src_unpack() {
	unpack ${A} && cd ${S}
	# bug 94069
	epatch ${FILESDIR}/${P}-fix-insecure-tmp-creation.diff
}

src_test() {
	make test || die "make test failed"
}

src_install() {
	insinto /usr/lib/log4sh
	doins build/log4sh || die "Failed to install log4sh"

	dodoc doc/CHANGES doc/TODO
	dohtml doc/*.{html,css}
	docinto examples
	dodoc src/examples/*
}

pkg_postinst() {
	echo
	elog "To use log4sh, have your script source /usr/lib/log4sh/log4sh."
	echo
}
