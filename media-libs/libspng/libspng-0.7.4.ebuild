# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Simple, modern libpng alternative."
HOMEPAGE="https://libspng.org"
SRC_URI="https://github.com/randy408/libspng/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="sys-libs/zlib
	test? ( media-libs/libpng )"
RDEPEND="${DEPEND}"

src_configure() {
	local emesonargs=(
		$(meson_use amd64 enable_opt)
		$(meson_use test dev_build)
	)
	meson_src_configure
}
