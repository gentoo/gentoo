# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit toolchain-funcs

DESCRIPTION="framebuffer pdf and djvu viewer"
HOMEPAGE="http://repo.or.cz/fbpdf.git"
SRC_URI="https://dev.gentoo.org/~slyfox/distfiles/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=app-text/mupdf-1.7:0=
	dev-lang/mujs:0=
	media-libs/freetype:2=
	media-libs/jbig2dec:0=
	virtual/jpeg:0=
	media-libs/openjpeg:0=
	dev-libs/openssl:0=
	app-text/djvu:0=
"

DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin fbpdf fbdjvu
	dodoc README
}
