# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit toolchain-funcs

MY_P="${PN}-src-${PV}"

DESCRIPTION="Plausible deniable file cryptography"
HOMEPAGE="http://www.winstonsmith.info/julia/elettra/"
SRC_URI="http://www.winstonsmith.info/julia/elettra/${MY_P}.tar.gz"

LICENSE="WTFPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="sys-libs/zlib
		 app-crypt/mhash
		 dev-libs/libmcrypt"

DEPEND="${RDEPEND}"

S="${WORKDIR}/${PN}"

src_compile() {
	$(tc-getCC) ${CFLAGS} ${LDFLAGS} -I. src/*.c \
		-lz `libmcrypt-config --cflags --libs` -lmhash \
		-o elettra || die "compilation failed"
}

src_install() {
	dobin elettra || die "dobin failed"
	dodoc README || die "dodoc failed"
}
