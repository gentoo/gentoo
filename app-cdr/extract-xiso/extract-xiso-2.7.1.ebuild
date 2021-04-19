# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PV=${PV/_beta/b}

DESCRIPTION="Tool for extracting and creating optimised Xbox ISO images"
HOMEPAGE="https://sourceforge.net/projects/extract-xiso"
SRC_URI="mirror://sourceforge/extract-xiso/${P}.tar.gz"
S="${WORKDIR}"/${PN}

LICENSE="BSD-4"
SLOT="0"
KEYWORDS="amd64 ppc x86"

PATCHES=(
	"${FILESDIR}"/${PN}-2.7.1-headers.patch
)

src_prepare() {
	default

	sed -i \
		-e 's:__LINUX__:__linux__:' \
		*.[ch] */*.[ch] || die
}

doit() { echo "$@"; "$@"; }

src_compile() {
	# Need _GNU_SOURCE here for asprintf prototype.
	doit $(tc-getCC) ${CFLAGS} ${CPPFLAGS} -D_GNU_SOURCE ${LDFLAGS} \
		extract-xiso.c libftp-*/*.c -o extract-xiso || die
}

src_install() {
	dobin extract-xiso
	dodoc README.TXT
}
