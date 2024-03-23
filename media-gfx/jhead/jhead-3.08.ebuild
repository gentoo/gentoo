# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="EXIF JPEG camera setting parser and thumbnail remover"
HOMEPAGE="http://www.sentex.net/~mwandel/jhead"
SRC_URI="https://github.com/Matthias-Wandel/jhead/archive/refs/tags/${PV}.tar.gz -> ${P}.tgz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-3.08-fix-makefile.patch
)

src_compile() {
	# Older codebase with aliasing violations (bug #890252)
	append-flags -fno-strict-aliasing
	filter-lto

	emake CC="$(tc-getCC)"
}

src_install() {
	dobin ${PN}
	dodoc *.txt
	docinto html
	dodoc *.html
	doman ${PN}.1
	doheader ${PN}.h
	dolib.so lib${PN}.so*
}
