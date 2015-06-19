# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/tablelist/tablelist-5.8.ebuild,v 1.4 2015/03/25 13:56:26 ago Exp $

EAPI=5

inherit multilib

MY_P="${PN}${PV}"

DESCRIPTION="Multi-Column Listbox Package"
HOMEPAGE="http://www.nemethi.de/tablelist/index.html"
SRC_URI="http://www.nemethi.de/tablelist/${MY_P}.tar.gz"

LICENSE="tablelist"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux"
IUSE="examples doc"

RDEPEND="dev-lang/tcl:0"
DEPEND=""

S="${WORKDIR}/${MY_P}"

src_install() {
	insinto /usr/$(get_libdir)/${MY_P}
	doins -r ${PN}* pkgIndex.tcl scripts
	use doc && dohtml doc/*
	use examples && insinto /usr/share/${PN} && doins -r demos
	dodoc README.txt
}
