# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs

DESCRIPTION="Utility that converts ASCII files between the MSDOS and the Unix format"
HOMEPAGE="http://tofrodos.sourceforge.net/"
SRC_URI="http://tofrodos.sourceforge.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}/src"

PATCHES=( "${FILESDIR}"/${PN}-1.7.13-CFLAGS.patch )

src_compile() {
	emake DEBUG=1 CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)"
}

src_install() {
	dobin fromdos
	dosym fromdos /usr/bin/todos
	doman fromdos.1
}
