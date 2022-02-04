# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A tool for reading kernel uevent(s) to stdout"
HOMEPAGE="http://www.bellut.net/projects.html"
# wget --user puppy --password linux "http://bkhome.org/sources/alphabetical/h/${P}.tar.gz"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

src_prepare() {
	default

	# Clean up prebuilt binary
	rm -f ${PN} || die
}

src_compile() {
	elog "$(tc-getCC) ${CPPFLAGS} ${CFLAGS} ${LDFLAGS} ${PN}.c -o ${PN}"
	$(tc-getCC) ${CPPFLAGS} ${CFLAGS} ${LDFLAGS} ${PN}.c -o ${PN} || die
}

src_install() {
	dobin ${PN}
}
