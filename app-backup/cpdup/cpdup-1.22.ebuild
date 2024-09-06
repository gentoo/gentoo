# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Comprehensive filesystem mirroring program"
HOMEPAGE="https://github.com/DragonFlyBSD/cpdup"
SRC_URI="https://github.com/DragonFlyBSD/cpdup/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-libs/libbsd"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	tc-export CC PKG_CONFIG
}

src_install() {
	dobin cpdup
	doman cpdup.1
	dodoc -r scripts
}
