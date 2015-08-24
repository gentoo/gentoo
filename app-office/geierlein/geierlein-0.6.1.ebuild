# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Submit tax forms (Umsatzsteuervoranmeldung) to the german digital tax project ELSTER"
HOMEPAGE="https://stesie.github.com/geierlein/"
SRC_URI="https://github.com/stesie/geierlein/archive/V${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RDEPEND="|| ( www-client/firefox www-client/firefox-bin )"
DEPEND=""

# needs nodejs and a couple of modules we don't have packaged
RESTRICT="test"

src_compile() {
	emake prefix=/usr
}

src_install() {
	emake \
		DESTDIR="${D}" \
		prefix=/usr \
		install || die
	dodoc README.md
}
