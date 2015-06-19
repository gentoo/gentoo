# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/libchart/libchart-1.3.ebuild,v 1.2 2014/08/10 21:00:00 slyfox Exp $

EAPI="4"

DESCRIPTION="Libchart is a chart creation PHP library that is easy to use"
HOMEPAGE="http://naku.dohcrew.com/libchart"
SRC_URI="http://libchart.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3 BitstreamVera"
KEYWORDS="~x86 ~amd64"
SLOT=0
IUSE="examples"

DEPEND=""
RDEPEND="dev-lang/php[truetype]
	|| ( dev-lang/php[gd] dev-lang/php[gd-external] )"

S="${WORKDIR}/${PN}"

src_install() {
	dodoc "${PN}/ChangeLog" "${PN}/README"
	rm -f "${PN}/ChangeLog" "${PN}/ChangeLog" "${PN}/COPYING"

	if use examples ; then
		# no point making users unzip all files individually
		docompress -x "/usr/share/doc/${PF}/demo"
		dodoc -r demo/
	fi

	insinto "/usr/share/php/${PN}"
	doins -r ${PN}
}
