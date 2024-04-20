# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit edos2unix

MYP=${PN}-${PV/_alpha/a}

DESCRIPTION="Visual Tcl is a high-quality application development environment"
HOMEPAGE="http://vtcl.sf.net"
SRC_URI="mirror://sourceforge/${PN}/${MYP}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="doc"
DEPEND="dev-lang/tk:*"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MYP}

MY_DESTDIR=/usr/share/${PN}

PATCHES=( "${FILESDIR}"/${P}-tk86.patch )

src_prepare() {
	edos2unix configure
	default
}

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
