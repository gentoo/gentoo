# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Provides settings to X11 applications via the XSETTINGS specification"
HOMEPAGE="https://github.com/derat/xsettingsd"
SRC_URI="https://github.com/derat/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-return-1.patch
	"${FILESDIR}"/${P}-add-cmake-buildsystem.patch
)
