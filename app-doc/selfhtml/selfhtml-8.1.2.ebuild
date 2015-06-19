# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-doc/selfhtml/selfhtml-8.1.2.ebuild,v 1.5 2015/01/15 14:16:36 mrueg Exp $

EAPI=5

S=${WORKDIR}
TARGET=/usr/share/doc/${PF}/html
DESCRIPTION="\"The\" German HTML/XHTML/CSS/XML/DHTML/CGI/Perl/JavaScript Documentation"
SRC_URI="http://aktuell.de.selfhtml.org/cgi-bin/selfdown/download.pl/${PN}${PV//\./}.zip"
HOMEPAGE="http://selfhtml.org"
DEPEND="app-arch/unzip"
SLOT="0"
LICENSE="selfhtml"
KEYWORDS="alpha amd64 hppa ~mips ppc sparc x86"
IUSE=""

src_install() {
	dodir "${TARGET}"
	cp -pR "${S}/"* "${D}${TARGET}"
}
