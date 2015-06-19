# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dialup/radiusclient/radiusclient-0.3.2-r1.ebuild,v 1.1 2013/06/27 16:32:06 pinkbyte Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1
inherit autotools-utils

DESCRIPTION="A library for writing RADIUS clients accompanied with several client utilities"
HOMEPAGE="http://freshmeat.net/projects/radiusclient/"
SRC_URI="ftp://ftp.cityline.net/pub/radiusclient/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="static-libs"

DEPEND="!net-dialup/radiusclient-ng
	!net-dialup/freeradius-client"
RDEPEND="${DEPEND}"

DOCS=( BUGS CHANGES README )
HTML_DOCS=( doc/instop.html )
PATCHES=(
	"${FILESDIR}/pkgsysconfdir-install.patch"
	"${FILESDIR}/${P}-64bit-compat.patch" # bug #399433
)
