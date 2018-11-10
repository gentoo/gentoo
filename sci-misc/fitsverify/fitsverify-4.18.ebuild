# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="FITS file format checker"
HOMEPAGE="https://heasarc.gsfc.nasa.gov/docs/software/ftools/fitsverify/"
SRC_URI="${HOMEPAGE}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="sci-libs/cfitsio:0="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${PN}"

src_compile() {
	$(tc-getCC) ${CPPFLAGS} -DSTANDALONE ${CFLAGS} ${LDFLAGS} \
		$($(tc-getPKG_CONFIG) --cflags cfitsio) \
		ftverify.c fvrf*.c \
		$($(tc-getPKG_CONFIG) --libs cfitsio) -o ${PN} \
		|| die "compiled failed"
}

src_install() {
	dobin fitsverify
	dodoc README
}
