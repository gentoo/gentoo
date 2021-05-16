# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs readme.gentoo-r1

DESCRIPTION="Convert JPEG images to Postscript using a wrapper"
HOMEPAGE="https://web.archive.org/web/20131003144811/http://www.pdflib.com/download/free-software/jpeg2ps/"
SRC_URI="https://web.archive.org/web/20131003165952/http://www.pdflib.com/fileadmin/pdflib/products/more/${PN}/${P}.tar.gz"

LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="metric"

PATCHES=("${FILESDIR}"/${P}-include.diff)

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC)" \
		CFLAGS="-c ${CFLAGS} $(usex metric "-DA4" "")" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin jpeg2ps
	doman jpeg2ps.1
	dodoc jpeg2ps.txt

	if use metric; then
		DOC_CONTENTS="By default, this installation of jpeg2ps will generate
			A4 size output.  You can force letter output with
			\n\tjpeg2ps -p letter file.jpg > file.ps"
	else
		DOC_CONTENTS="By default, this installation of jpeg2ps will generate
			letter size output.  You can force A4 output with
			\n\tjpeg2ps -p a4 file.jpg > file.ps"
	fi
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
