# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/radiusclient-ng/radiusclient-ng-0.5.6-r1.ebuild,v 1.4 2015/01/27 10:08:26 pinkbyte Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1
inherit autotools-utils eutils toolchain-funcs

DESCRIPTION="RadiusClient NextGeneration - library for RADIUS clients accompanied with several client utilities"
HOMEPAGE="http://sourceforge.net/projects/radiusclient-ng.berlios/"
SRC_URI="mirror://sourceforge/${PN}.berlios/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="static-libs"

DEPEND="!net-dialup/radiusclient
	!net-dialup/freeradius-client"
RDEPEND="${DEPEND}"

DOCS=( BUGS CHANGES README )
HTML_DOCS=( doc/instop.html )

PATCHES=( "${FILESDIR}/${P}-cross-compile.patch" )

src_prepare() {
	# bug #373365
	if tc-is-cross-compiler ; then
		export ac_cv_file__dev_urandom=yes
		export ac_cv_struct_utsname=no
	fi

	autotools-utils_src_prepare
}
