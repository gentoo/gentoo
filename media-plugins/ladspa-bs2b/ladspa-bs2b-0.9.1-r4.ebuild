# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit autotools

DESCRIPTION="LADSPA plugin for bs2b headphone filter"
HOMEPAGE="http://bs2b.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/bs2b/plugins/LADSPA%20plugin/${PV}/${P}.tar.bz2"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="media-libs/ladspa-sdk
		>=media-libs/libbs2b-3.1.0"

RDEPEND="${DEPEND}"

src_prepare() {
	default
	sed 's,dist-lzma,,' -i configure.ac || die
	eautoreconf  # bug 889426
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
