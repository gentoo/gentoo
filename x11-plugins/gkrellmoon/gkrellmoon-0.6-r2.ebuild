# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gkrellm-plugin toolchain-funcs

DESCRIPTION="A GKrellM2 plugin of the famous wmMoonClock dockapp"
SRC_URI="mirror://sourceforge/gkrellmoon/${P}.tar.gz"
HOMEPAGE="http://gkrellmoon.sourceforge.net/"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="alpha amd64 ppc sparc x86"
IUSE=""

RDEPEND="
	app-admin/gkrellm:2[X]
	media-libs/imlib2"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_prepare() {
	default
	sed -i -e '/^#include <stdio.h>/a#include <string.h>' CalcEphem.h || die
}

src_compile() {
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}
