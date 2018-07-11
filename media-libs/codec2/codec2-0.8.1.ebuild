# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib

DESCRIPTION="Low bit rate speech codec"
HOMEPAGE="https://freedv.org/"
SRC_URI="https://hobbes1069.fedorapeople.org/freetel/codec2/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~x86"
IUSE="examples"

DEPEND=""
RDEPEND="${DEPEND}"

multilib_src_configure() {
	local mycmakeargs=( -DUNITTEST=OFF )
	cmake-utils_src_configure
}

src_install() {
	cmake-multilib_src_install

	if use examples; then
		insinto /usr/share/codec2
		doins -r wav raw
	fi
}
