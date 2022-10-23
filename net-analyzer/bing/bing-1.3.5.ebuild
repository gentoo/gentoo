# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A point-to-point bandwidth measurement tool"
HOMEPAGE="http://fgouget.free.fr/bing/index-en.shtml"
SRC_URI="mirror://debian/pool/main/b/bing/${PN}_${PV}.orig.tar.gz"

LICENSE="BSD-4"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ia64 ~ppc ~sparc ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-1.3.5-Add-missing-string.h-for-memcpy.patch
)

src_prepare() {
	default
	sed -i -e "s|#COPTIM = -g| COPTIM = ${CFLAGS}|" Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin bing
	doman unix/bing.8
	dodoc ChangeLog Readme.{1st,txt}
}
