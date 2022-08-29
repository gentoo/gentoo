# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gkrellm-plugin toolchain-funcs

DESCRIPTION="A GKrellM2 plugin of the famous wmMoonClock dockapp"
HOMEPAGE="http://gkrellmoon.sourceforge.net/"
SRC_URI="mirror://sourceforge/gkrellmoon/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~alpha amd64 ~ppc sparc x86"

RDEPEND="
	app-admin/gkrellm:2[X]
	media-libs/imlib2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-r3-pkgconfig.patch
	"${FILESDIR}"/${P}-r3-include-stringh.patch
)

src_compile() {
	tc-export PKG_CONFIG
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}
