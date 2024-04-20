# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gkrellm-plugin toolchain-funcs

DESCRIPTION="A GKrellM2 plugin to control a fli4l router"
HOMEPAGE="http://gkrellm-imonc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-src-${PV}.tar.bz2"
S="${WORKDIR}/${PN}-src-${PV}"

# The COPYING file contains the GPLv2, but the file headers say GPLv2+.
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="app-admin/gkrellm:2[X]"
DEPEND="
	${RDEPEND}
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-makefile.patch
	"${FILESDIR}"/${P}-r2-pkgconfig.patch
)

src_compile() {
	tc-export PKG_CONFIG
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}
