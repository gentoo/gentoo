# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A simple implementation of freedesktop.org notification area for X"
HOMEPAGE="https://steelman.github.io/xystray/"
SRC_URI="https://github.com/steelman/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXt"
DEPEND="${RDEPEND}
	x11-libs/libXaw"

PATCHES=(
	"${FILESDIR}/${P}-ldflags.patch"
)

src_install() {
	dobin xystray
}
