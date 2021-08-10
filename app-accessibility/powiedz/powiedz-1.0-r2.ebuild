# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop toolchain-funcs

DESCRIPTION="Polish speech synthesizer based on rsynth"
HOMEPAGE="http://kadu.net/index.php?page=download&lang=en"
SRC_URI="http://kadu.net/download/additions/${P}.tgz"
S="${WORKDIR}/${PN}"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0-dsp-handle-fix.patch
)

src_compile() {
	emake -f Makefile_plain LDLIBS="-lm" CFLAGS="${CFLAGS}" DEFS="" CC=$(tc-getCC)
}

src_install() {
	dobin powiedz
	domenu "${FILESDIR}"/${PN}.desktop
}
