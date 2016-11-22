# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit gkrellm-plugin toolchain-funcs

IUSE=""
DESCRIPTION="A GKrellM2 plugin of the famous wmMoonClock dockapp"
SRC_URI="mirror://sourceforge/gkrellmoon/${P}.tar.gz"
HOMEPAGE="http://gkrellmoon.sourceforge.net/"

DEPEND="media-libs/imlib2"
RDEPEND="${DEPEND}"

SLOT="2"
LICENSE="GPL-2"

KEYWORDS="alpha amd64 ppc sparc x86"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )

src_prepare() {
	default
	sed -i -e '/^#include <stdio.h>/a#include <string.h>' CalcEphem.h
}

src_compile() {
	emake CC="$(tc-getCC)" LDFLAGS="${LDFLAGS}"
}
