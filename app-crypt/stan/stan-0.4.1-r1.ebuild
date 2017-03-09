# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="Stan analyzes binary streams and calculates statistical information"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

PATCHES=(
	"${FILESDIR}/${P}-errno.patch"
)

src_prepare() {
	default

	mv configure.{in,ac} || die
	sed -i \
			-e "s/-O3/${CFLAGS}/" \
			-e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/g" configure.ac || die
	eautoreconf
}
