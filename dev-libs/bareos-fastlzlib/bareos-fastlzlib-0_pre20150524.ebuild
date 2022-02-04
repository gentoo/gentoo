# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Fork of zlib-like interface to fast block compression (LZ4 or FastLZ) libraries"
HOMEPAGE="https://github.com/bareos/fastlzlib"
SRC_URI="https://dev.gentoo.org/~mschiff/distfiles/${P}.zip"
S="${WORKDIR}/fastlzlib-master"

LICENSE="BSD-1 BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	!app-arch/lz4
"
BDEPEND="app-arch/unzip"

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
	find "${ED}" -type d -name libfastlz -exec rm -rf {} + || die
}
