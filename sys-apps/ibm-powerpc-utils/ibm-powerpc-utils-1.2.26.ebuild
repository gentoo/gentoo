# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/ibm-powerpc-utils/ibm-powerpc-utils-1.2.26.ebuild,v 1.1 2015/06/25 05:04:07 jer Exp $

EAPI=5
inherit eutils

DESCRIPTION="This package provides utilities for the maintainance
of the IBM and Apple powerpc platforms."
HOMEPAGE="http://sourceforge.net/projects/powerpc-utils"
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
