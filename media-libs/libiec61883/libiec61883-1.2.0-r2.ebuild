# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="Library for capturing video (dv or mpeg2) over the IEEE 1394 bus"
HOMEPAGE="https://ieee1394.wiki.kernel.org/index.php/Libraries#libiec61883"
SRC_URI="https://www.kernel.org/pub/linux/libs/ieee1394/${P}.tar.xz"

LICENSE="|| ( LGPL-2.1 GPL-2 )"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 sparc x86"
IUSE="examples"

RDEPEND=">=sys-libs/libraw1394-2.1.0-r1[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	default
	use examples && eapply "${FILESDIR}/${P}-examples.patch"
}

multilib_src_configure() {
	ECONF_SOURCE=${S} econf --disable-static
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
}
