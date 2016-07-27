# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils

DESCRIPTION="This package provides utilities for the maintainance
of the IBM and Apple powerpc platforms."
HOMEPAGE="https://sourceforge.net/projects/powerpc-utils"
SRC_URI="mirror://sourceforge/powerpc-utils/${P//ibm-}.tar.gz"
IUSE="+rtas"

S="${WORKDIR}/${P//ibm-}"

SLOT="0"
LICENSE="IBM"
KEYWORDS="~ppc ~ppc64"

DEPEND="
	sys-devel/bc
"
RDEPEND="
	rtas? ( >=sys-libs/librtas-1.3.5 )
	${DEPEND}
"

src_configure() {
	econf $(use_with rtas librtas)
}
