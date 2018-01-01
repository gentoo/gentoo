# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs flag-o-matic

DESCRIPTION="ipsvd is a set of internet protocol service daemons for Unix"
HOMEPAGE="http://smarden.org/ipsvd/"
SRC_URI="http://smarden.org/ipsvd/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/net/${P}"

PATCHES=(
	"${FILESDIR}"/${P}-fix-parallel-make.diff
)

src_configure() {
	cd "${S}"/src
	if use static ; then
		append-ldflags -static
	fi

	echo "$(tc-getCC) ${CFLAGS}"  > conf-cc
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld
}

src_compile() {
	cd "${S}"/src
	emake
}

src_install() {
	dobin src/{tcpsvd,udpsvd,ipsvd-cdb}
	dodoc package/{CHANGES,README}

	doman man/ipsvd-instruct.5 man/ipsvd.7 man/udpsvd.8 \
		man/tcpsvd.8 man/ipsvd-cdb.8

	insinto html
	dohtml doc/*.html
}
