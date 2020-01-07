# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="Library for the 1394 AV/C (Audio/Video Control) Digital Interface Command Set"
HOMEPAGE="https://sourceforge.net/projects/libavc1394/"
SRC_URI="mirror://sourceforge/libavc1394/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

BDEPEND="virtual/pkgconfig[${MULTILIB_USEDEP}]"
DEPEND=">=sys-libs/libraw1394-2.1.0-r1[${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}"

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf --disable-static
}

multilib_src_install_all() {
	einstalldocs
	find "${D}" -name '*.la' -type f -delete || die
}
