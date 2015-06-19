# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/freexl/freexl-1.0.0e.ebuild,v 1.6 2015/01/05 15:48:39 aballier Exp $

EAPI=5

inherit eutils

DESCRIPTION="Simple XLS data extraction library"
HOMEPAGE="http://www.gaia-gis.it/gaia-sins/"
SRC_URI="http://www.gaia-gis.it/gaia-sins/${PN}-sources/${P}.tar.gz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86"
IUSE="static-libs"

DEPEND="virtual/libiconv"
RDEPEND="${DEPEND}"

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_install() {
	default

	prune_libtool_files --all
}
