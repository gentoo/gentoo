# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Network traffic statics utility for Solaris and Linux"
HOMEPAGE="https://sourceforge.net/projects/nicstat/ https://github.com/scotte/nicstat/"
EGIT_COMMIT="a716ee81cbf1e177267e20a880b5a0d9fa5b689e"
SRC_URI="https://github.com/scotte/nicstat/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	$(tc-getCC) ${CFLAGS} ${PN}.c -o ${PN} ${LDFLAGS} || die
}

src_install() {
	dobin {e,}${PN}
	doman ${PN}.1
	dodoc BUGS.md ChangeLog.txt README*
}
