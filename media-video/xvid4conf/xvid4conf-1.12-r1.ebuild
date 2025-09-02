# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="GTK2-configuration dialog for xvid4"
HOMEPAGE="http://cvs.exit1.org/cgi-bin/viewcvs.cgi/xvid4conf/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ppc ppc64 ~sparc x86"

RDEPEND=">=x11-libs/gtk+-2.2.4:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default

	sed -i -e "s:configure.in:configure.ac:" configure.in || die

	# bug #899916
	eautoreconf
}
