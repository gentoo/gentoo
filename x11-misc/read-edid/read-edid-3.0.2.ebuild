# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils flag-o-matic

DESCRIPTION="Program that can get information from a PnP monitor"
HOMEPAGE="http://www.polypux.org/projects/read-edid/"
SRC_URI="http://www.polypux.org/projects/${PN}/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="-* amd64 x86"

DEPEND=">=dev-libs/libx86-1.1"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e 's|COPYING||g;s|share/doc/read-edid|&-'"${PV}"'|g' \
		CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	append-cflags -fcommon
	cmake-utils_src_configure
}
