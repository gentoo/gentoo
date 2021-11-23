# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Lets you easily embed LaTeX math in your own html pages, blogs, wikis, etc"
HOMEPAGE="https://www.ctan.org/pkg/mathtex"
SRC_URI="https://mirrors.ctan.org/support/${PN}.zip -> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="png"

RDEPEND="app-text/dvipng
	virtual/latex-base"
BDEPEND="app-arch/unzip"

S=${WORKDIR}/${PN}

einfo_run_command() {
	einfo "${@}"
	${@} || die
}

src_compile() {
	einfo_run_command $(tc-getCC) \
		${CFLAGS} ${LDFLAGS} \
		-DLATEX=\"/usr/bin/latex\" \
		-DDVIPNG=\"/usr/bin/dvipng\" \
		$(use png && echo "-DPNG") \
		mathtex.c -o mathtex
}

src_install() {
	dobin mathtex
	dodoc README mathtex.html
}

pkg_postinst() {
	elog "To use mathtex in your web-pages, just link /usr/bin/mathtex"
	elog "to your cgi-bin subdirectory!"
}
