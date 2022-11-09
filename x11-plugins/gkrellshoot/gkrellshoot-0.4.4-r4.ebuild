# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gkrellm-plugin toolchain-funcs

DESCRIPTION="GKrellm2 plugin to take screen shots and lock screen"
HOMEPAGE="http://gkrellshoot.sourceforge.net/"
SRC_URI="mirror://sourceforge/gkrellshoot/${P}.tar.gz"
S="${WORKDIR}/${P/s/S}"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~alpha amd64 ~ppc sparc x86"

DEPEND="app-admin/gkrellm:2[X]"
RDEPEND="
	${DEPEND}
	virtual/imagemagick-tools"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/makefile-respect-flags.patch
	"${FILESDIR}/${P}"-r4-pkgconfig.patch
)

src_compile() {
	tc-export PKG_CONFIG
	default
}
