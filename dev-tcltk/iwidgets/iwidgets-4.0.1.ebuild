# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/iwidgets/iwidgets-4.0.1.ebuild,v 1.21 2013/01/19 10:17:04 ulm Exp $

MY_P=${PN}${PV}
ITCL_MY_PN="itcl"
ITCL_MY_PV="3.2.1"
ITCL_MY_P="${ITCL_MY_PN}${ITCL_MY_PV}"

DESCRIPTION="Widget collection for incrTcl/incrTk"
HOMEPAGE="http://incrtcl.sourceforge.net/itcl/"
SRC_URI="
	mirror://sourceforge/incrtcl/${MY_P}.tar.gz
	mirror://sourceforge/incrtcl/${ITCL_MY_P}_src.tgz"

LICENSE="HPND Old-MIT tcltk"
SLOT="0"
KEYWORDS="~alpha amd64 ia64 ppc sparc x86"
IUSE=""

DEPEND="
	>=dev-tcltk/itcl-3.2.1
	>=dev-tcltk/itk-3.3-r1"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_compile() {
	local myconf
	myconf="${myconf} --with-itcl=${WORKDIR}/${ITCL_MY_P}"
	econf ${myconf}
}

src_install() {
	einstall || die "einstall failed"
	dodoc CHANGES ChangeLog README || die
	# Bug 115470
	rm doc/panedwindow.n
	doman doc/*.n || die
}
