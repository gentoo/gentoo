# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_P="${P/engines/engine}"

DESCRIPTION="GTK+ Experience Theme Engine"
HOMEPAGE="http://benjamin.sipsolutions.net/Projects/eXperience"
SRC_URI="http://benjamin.sipsolutions.net/experience/${MY_P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="2"
KEYWORDS="amd64 ~ppc ~sparc x86"

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

src_prepare() {
	default
	eautoreconf # update stale libtool
}

src_install() {
	default

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
