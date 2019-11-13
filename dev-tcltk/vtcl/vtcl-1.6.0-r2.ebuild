# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Visual Tcl is a high-quality application development environment"
HOMEPAGE="http://vtcl.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc"
DEPEND="dev-lang/tk:*"
RDEPEND="${DEPEND}"

MY_DESTDIR=/usr/share/${PN}

src_compile() {
	sed -i 's,^\(VTCL_HOME=\).*,\1'${MY_DESTDIR}',g' vtcl	|| die "Path fixing failed."
	sed -i 's,package require -exact Tk ,package require Tk ,' lib/tkcon.tcl || die "Tcl8.5 patch failed"
}

src_install() {
	dodir ${MY_DESTDIR}
	dobin vtcl
	cp -r ./{demo,images,lib,sample,vtcl.tcl} "${D}/${MY_DESTDIR}" || die "Data installation failed."
	if use doc; then
		DOCS=( ChangeLog README doc/tutorial.txt )
		HTML_DOCS=( doc/*html )
	fi
	einstalldocs
}
