# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="Fork of zlib-like interface to fast block compression (LZ4 or FastLZ) libraries"
HOMEPAGE="https://github.com/bareos/fastlzlib"
SRC_URI="https://dev.gentoo.org/~mschiff/distfiles/${P}.zip"

LICENSE="BSD-1 BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	!app-arch/lz4
"

S="${WORKDIR}/fastlzlib-master"

src_configure() {
	econf --disable-static
}

src_install() {
	emake DESTDIR="${D}" install
	find "${ED}" -name '*.la' -delete || die
	find "${D}" -type d -name libfastlz -exec rm -rf {} +
}
