# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="vector optimized library of kernels"
HOMEPAGE="http://libvolk.org"
SRC_URI="https://github.com/gnuradio/volk/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="+orc"

RDEPEND="!<net-wireless/gnuradio-3.8
	dev-libs/boost
	dev-lang/orc"
DEPEND="${RDEPEND}
	dev-python/mako
	dev-python/six"

#https://github.com/gnuradio/volk/issues/382
RESTRICT=test

CMAKE_BUILD_TYPE=Release

src_configure() {
	local mycmakeargs=(
		-DENABLE_ORC=$(usex orc)
	)
	cmake-utils_src_configure
}
