# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/libtcd/libtcd-2.2.5_p2.ebuild,v 1.3 2013/09/02 08:14:23 ago Exp $

EAPI=5

inherit eutils

MY_P=${PN}-${PV/_p/-r}
DESCRIPTION="Library for reading and writing Tide Constituent Database (TCD) files"
HOMEPAGE="http://www.flaterco.com/xtide/libtcd.html"
SRC_URI="ftp://ftp.flaterco.com/xtide/${MY_P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc static-libs"

DEPEND=">=sci-geosciences/harmonics-dwf-free-20120302"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${P%_*}

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || prune_libtool_files
	use doc && dohtml libtcd.html
}
