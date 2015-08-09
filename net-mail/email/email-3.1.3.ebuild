# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

DESCRIPTION="Advanced CLI tool for sending email"
HOMEPAGE="http://www.cleancode.org/projects/email"
SRC_URI="http://www.cleancode.org/downloads/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="alpha amd64 x86"
IUSE=""

src_prepare() {
	sed -i -e "s:/doc/email-\${version}:/share/doc:" configure || die
	sed -i -e "s:DIVIDER = '---':DIVIDER = '-- ':" email.conf || die
}

src_install() {
	default
	doman email.1
	dodoc README TODO
}
