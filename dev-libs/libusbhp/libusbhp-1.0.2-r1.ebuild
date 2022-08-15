# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="USB Hotplug Library"
HOMEPAGE="http://www.aasimon.org/libusbhp/"
SRC_URI="http://www.aasimon.org/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~x86"

RDEPEND=">=virtual/libudev-147"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	econf \
		--disable-static \
		--without-debug
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
