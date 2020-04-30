# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="md4 and edonkey hash algorithm tool"
HOMEPAGE="https://linux.xulin.de/c/"
SRC_URI="https://linux.xulin.de/c/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

PATCHES=( "${FILESDIR}"/md4sum-fix-out-of-bounds-write.diff )

src_prepare() {
	default
	sed -i -e "s;CFLAGS=;CFLAGS=${CFLAGS} ;g" \
		-e "s:install -s:install:g" Makefile.Linux || die
}

src_compile() {
	emake LDFLAGS="${LDFLAGS}" CC="$(tc-getCC)"
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
}
