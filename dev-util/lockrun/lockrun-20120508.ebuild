# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/lockrun/lockrun-20120508.ebuild,v 1.5 2012/07/03 20:30:35 jer Exp $

EAPI=4
inherit toolchain-funcs

DESCRIPTION="Lockrun - runs cronjobs with overrun protection"
HOMEPAGE="http://www.unixwiz.net/tools/lockrun.html"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 hppa x86"
IUSE=""

S="${WORKDIR}"

src_unpack() {
	cp "${FILESDIR}"/${PN}.c-${PV} "${S}"/${PN}.c || die
	cp "${FILESDIR}"/${PN}.c-${PV} "${S}"/README || die
}

src_compile() {
	emake CC=$(tc-getCC) ${PN}
	sed -i README -e '60q;s|^ \*||g' || die
}

src_install () {
	dobin ${PN}
	dodoc README
}
