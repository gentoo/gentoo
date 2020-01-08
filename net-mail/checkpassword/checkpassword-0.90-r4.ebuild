# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit fixheadtails toolchain-funcs

DESCRIPTION="A uniform password checking interface for root applications"
HOMEPAGE="https://cr.yp.to/checkpwd.html"
SRC_URI="https://cr.yp.to/checkpwd/${P}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE="static"
RESTRICT="mirror bindist"

PATCHES=(
	"${FILESDIR}"/${P}-errno.patch
	"${FILESDIR}"/${P}-exit.patch
	"${FILESDIR}"/${P}-headers.patch
)

src_prepare() {
	default

	ht_fix_file Makefile print-cc.sh

	use static && append-ldflags -static

	echo "$(tc-getCC) ${CFLAGS} ${CPPFLAGS}" > ./conf-cc || die 'Patching conf-cc failed.'
	echo "$(tc-getCC) ${LDFLAGS}" > ./conf-ld || die 'Patching conf-ld failed.'
}

src_install() {
	dobin checkpassword
	einstalldocs
}
