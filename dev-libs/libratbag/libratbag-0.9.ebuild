# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit meson udev

DESCRIPTION="Library to configure gaming mice"
HOMEPAGE="https://github.com/libratbag/libratbag"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen )
"
RDEPEND="
	dev-libs/libevdev
	virtual/libudev
"

src_prepare() {
	default

	sed '/default:/d' -i meson_options.txt || die
}

src_configure() {
	local emesonargs=(
		-Denable-documentation=$(usex doc true false)
		-Denable-tests=$(usex test true false)
		-Dudev-dir=$(get_udevdir)
	)
	meson_src_configure
}
