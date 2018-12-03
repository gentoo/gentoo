# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

inherit eutils

DESCRIPTION="Yet another metadata injector for FLV"
HOMEPAGE="http://yamdi.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""

DEPEND="${RDEPEND}"
RDEPEND="${RDEPEND}"

src_compile() {
	# upstream provides a rudimentary Makefile, so we'd rather compile the .c file here
	$(tc-getCC ) ${CFLAGS} -o ${PN} ${PN}.c || die "compilation failed"
}

src_install() {
	dodoc CHANGES README
	dobin yamdi
	doman man1/yamdi.1
}

pkg_postinst() {
	elog "You can use ${PN} to index FLV files that were recorded with one of nginx's rtmp modules."
	elog "eg. exec_record_done /usr/bin/${PN} -i \$path -o \$dirname/indexed_\$filename;"
}
