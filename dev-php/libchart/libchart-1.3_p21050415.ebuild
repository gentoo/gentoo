# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit vcs-snapshot

DESCRIPTION="Libchart is a chart creation PHP library that is easy to use"
HOMEPAGE="http://naku.dohcrew.com/libchart"
SRC_URI="https://github.com/naku/libchart/archive/af1628453cc083ede980c78216da8f2f594da6fa.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3 BitstreamVera"
KEYWORDS="~x86 ~amd64"
SLOT=0
IUSE="examples"

DEPEND=""
RDEPEND="dev-lang/php:*[gd,truetype]"

DOCS=( ChangeLog README.md )

src_install() {
	#remove extra license files
	rm -r "${S}/${PN}/doc" || die
	einstalldocs

	if use examples ; then
		# no point making users unzip all files individually
		docompress -x "/usr/share/doc/${PF}/demo"
		dodoc -r demo/
	fi

	insinto "/usr/share/php/${PN}"
	doins -r ${PN}/*
}

pkg_postinst() {
	elog
	elog "This version removes the duplicated /usr/share/php/libchart/libchart"
	elog "in favor of /usr/share/php/libchart.  Please update any scripts in order"
	elog "for the classes to be found."
	elog
}
