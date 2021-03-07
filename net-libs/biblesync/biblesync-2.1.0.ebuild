# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A multicast protocol to support Bible software shared co-navigation"
HOMEPAGE="https://wiki.crosswire.org/BibleSync"
SRC_URI="https://github.com/karlkleinpaste/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64"
IUSE="static"

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=$(usex !static)
		# To prevent multilib-strict violations
		-DLIBDIR="${EPREFIX}"/usr/$(get_libdir)
	)
	cmake_src_configure
}
