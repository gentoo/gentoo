# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="Simple XLS data extraction library"
HOMEPAGE="http://www.gaia-gis.it/gaia-sins/"
SRC_URI="http://www.gaia-gis.it/gaia-sins/${PN}-sources/${P}.tar.gz"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc ppc64 x86"
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
