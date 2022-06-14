# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edos2unix toolchain-funcs readme.gentoo-r1

DESCRIPTION="Convert JPEG images to Postscript using a wrapper"
HOMEPAGE="https://web.archive.org/web/20131003144811/http://www.pdflib.com/download/free-software/jpeg2ps/"
SRC_URI="https://web.archive.org/web/20131003165952/http://www.pdflib.com/fileadmin/pdflib/products/more/${PN}/${P}.zip"

LICENSE="jpeg2ps"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="metric"
RESTRICT="mirror"

BDEPEND="app-arch/unzip"

PATCHES=("${FILESDIR}"/${P}-include.diff)

src_prepare() {
	edos2unix Makefile *.c *.h *.1 *.txt
	default
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC)" \
		CFLAGS="-c ${CFLAGS} $(usev metric -DA4)" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin jpeg2ps
	doman jpeg2ps.1
	dodoc jpeg2ps.txt

	local size1=letter size2=A4
	use metric && size1=A4 size2=letter
	DOC_CONTENTS="By default, this installation of jpeg2ps will generate
		${size1} size output. You can force ${size2} output with
		\n\tjpeg2ps -p ${size2} file.jpg > file.ps"
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
