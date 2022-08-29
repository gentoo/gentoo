# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gkrellm-plugin toolchain-funcs

DESCRIPTION="A Program-Launcher Plugin for GKrellM2"
SRC_URI="mirror://sourceforge/gkrellmlaunch/${P}.tar.gz"
HOMEPAGE="http://gkrellmlaunch.sourceforge.net/"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~alpha amd64 ~ppc sparc x86"

RDEPEND="app-admin/gkrellm:2[X]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-r1-pkgconfig.patch
)

src_compile() {
	tc-export PKG_CONFIG
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}
