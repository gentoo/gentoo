# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Zoned block device manipulation library and tools"
HOMEPAGE="https://github.com/westerndigitalcorporation/libzbd"
SRC_URI="https://github.com/westerndigitalcorporation/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+ LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="gtk"

DEPEND="virtual/pkgconfig
	>=sys-kernel/linux-headers-4.13
	gtk? ( x11-libs/gtk+:3 )"

PATCHES=(
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_with gtk gtk3) \
		--disable-static
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
