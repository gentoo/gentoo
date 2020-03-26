# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A simple implementation of freedesktop.org notification area for X"
HOMEPAGE="https://steelman.github.com/xystray/"
SRC_URI="https://github.com/steelman/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

CDEPEND="
	x11-libs/libX11
	x11-libs/libXt"
DEPEND="${CDEPEND}
	x11-libs/libXaw"
RDEPEND="${CDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-ldflags.patch"
)

src_install() {
	dobin xystray
}
