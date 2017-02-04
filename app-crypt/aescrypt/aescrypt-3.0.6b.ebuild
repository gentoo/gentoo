# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs flag-o-matic

DESCRIPTION="Advanced file encryption using AES"
HOMEPAGE="http://www.aescrypt.com/"
SRC_URI="https://www.aescrypt.com/download/v3/${P}.tar.gz"

LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="static"

DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-build.patch"
	"${FILESDIR}/${P}-iconv.patch"
)

src_compile() {
	if use static; then
		append-cflags "-DDISABLE_ICONV"
		append-ldflags "-static"
	fi
	emake CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" CC="$(tc-getCC)"
}
