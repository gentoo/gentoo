# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Lets you easily embed LaTeX math in your own html pages, blogs, wikis, etc"
HOMEPAGE="http://www.forkosh.com/mathtex.html"
SRC_URI="mirror://gentoo/${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="png"

RDEPEND="app-text/dvipng
	virtual/latex-base"
DEPEND="app-arch/unzip"

S=${WORKDIR}

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
	dodoc README
	dohtml mathtex.html
}

pkg_postinst() {
	elog "To use mathtex in your web-pages, just link /usr/bin/mathtex"
	elog "to your cgi-bin subdirectory!"
}
