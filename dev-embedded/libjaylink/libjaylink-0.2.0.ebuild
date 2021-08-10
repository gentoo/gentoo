# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools multilib-minimal

DESCRIPTION="Library to access J-Link devices"
HOMEPAGE="https://gitlab.zapb.de/libjaylink/libjaylink"

SRC_URI="https://gitlab.zapb.de/libjaylink/libjaylink/-/archive/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE="static-libs"

DEPEND="virtual/libusb:1[${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_prepare() {
	sed -i -e "/^JAYLINK_CFLAGS=/ s/ -Werror / /" configure.ac || die
	eapply_user
	eautoreconf
	multilib_copy_sources
}

multilib_src_configure() {
	econf $(use_enable static-libs static)
}

multilib_src_install_all() {
	einstalldocs
	use static-libs || find "${D}" -name '*.la' -delete || die
}
