# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_P=${PN}-v${PV/./-}
DESCRIPTION="Object-oriented Input System - A cross-platform C++ input handling library"
HOMEPAGE="https://sourceforge.net/projects/wgois/"
SRC_URI="mirror://sourceforge/wgois/${MY_P/-/_}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="static-libs"

DEPEND="x11-libs/libXaw
	x11-libs/libX11"

PATCHES=(
	"${FILESDIR}"/${P}-gcc47.patch
	"${FILESDIR}"/${P}-automake-1.13.patch
)

src_prepare() {
	default

	eautoreconf
}
