# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gkrellm-plugin toolchain-funcs

DESCRIPTION="A simple countdown clock for GKrellM2"
HOMEPAGE="http://freshmeat.sourceforge.net/projects/gkrellm-countdown"
SRC_URI="http://oss.pugsplace.net/${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc sparc x86"

RDEPEND="app-admin/gkrellm:2[X]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-makefile.patch
	"${FILESDIR}"/${P}-r2-pkgconfig.patch
)

src_compile() {
	tc-export PKG_CONFIG
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}
