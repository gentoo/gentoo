# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/congen/congen-1.6.2.ebuild,v 1.4 2014/08/10 20:27:32 slyfox Exp $

EAPI=5

inherit eutils

MY_P=${P/_p/-r}
DESCRIPTION="A package for generating the speeds, equilibrium arguments, and node factors of tidal constituents"
HOMEPAGE="http://www.flaterco.com/xtide/files.html"
SRC_URI="ftp://ftp.flaterco.com/xtide/${MY_P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

DEPEND=">=sci-geosciences/libtcd-2.2.3"
RDEPEND="${DEPEND}"

MAKEOPTS+=" -j1"

S=${WORKDIR}/${P%_p*}

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default
	use static-libs || prune_libtool_files
}
