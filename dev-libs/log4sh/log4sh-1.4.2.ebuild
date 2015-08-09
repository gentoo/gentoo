# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="A flexible logging framework for shell scripts"
HOMEPAGE="http://sourceforge.net/projects/log4sh"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86"
IUSE="examples"

RDEPEND="app-shells/bash"

src_compile() {
	emake build
}

src_test() {
	# testsuite needs USER variable
	export USER="$(whoami)"
	make test || die "make test failed"
}

src_install() {
	insinto /usr/lib/log4sh
	doins build/log4sh

	dodoc doc/*.txt
	dohtml doc/*.{html,css}

	if use examples; then
		docinto examples
		docompress -x /usr/share/doc/${PF}/examples
		dodoc src/examples/*
	fi
}

pkg_postinst() {
	elog "To use log4sh, have your script source /usr/lib/log4sh/log4sh"
	elog "If you want to use remote logging, you should install package,"
	elog "that provides netcat binary (for example - net-analyzer/netcat)"
}
