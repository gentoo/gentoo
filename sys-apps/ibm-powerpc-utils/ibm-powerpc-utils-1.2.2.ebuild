# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

MY_P="powerpc-utils-${PV}"

DESCRIPTION="This package provides utilities for the maintainance
of the IBM and Apple powerpc platforms."
HOMEPAGE="https://sourceforge.net/projects/powerpc-utils"
SRC_URI="mirror://sourceforge/powerpc-utils/${MY_P}.tar.gz"

S="${WORKDIR}/${MY_P}"

SLOT="0"
LICENSE="IBM"
KEYWORDS="ppc ppc64"
IUSE=""
DEPEND=">=sys-libs/librtas-1.3.1
		sys-devel/bc
		!sys-apps/ibm-powerpc-utils-papr"
RDEPEND="!sys-apps/ppc64-utils"

src_unpack() {
	unpack ${A}
}

src_install() {
	make DESTDIR="${D}" install || die "Something went wrong"

}
