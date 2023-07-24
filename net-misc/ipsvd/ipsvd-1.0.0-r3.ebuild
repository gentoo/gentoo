# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Set of internet protocol service daemons for Unix"
HOMEPAGE="http://smarden.org/ipsvd/"
SRC_URI="http://smarden.org/ipsvd/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/net/${P}"

PATCHES=(
	"${FILESDIR}"/${P}-fix-parallel-make.diff
	"${FILESDIR}"/${PN}-1.0.0-fix-musl-clang-16.patch
)

src_configure() {
	cd "${S}"/src

	echo "$(tc-getCC) ${CFLAGS}"  > conf-cc
	echo "$(tc-getCC) ${LDFLAGS}" > conf-ld
}

src_compile() {
	cd "${S}"/src || die
	emake
}

src_install() {
	dobin src/{tcpsvd,udpsvd,ipsvd-cdb}
	dodoc package/{CHANGES,README}

	doman man/ipsvd-instruct.5 man/ipsvd.7 man/udpsvd.8 \
		man/tcpsvd.8 man/ipsvd-cdb.8

	local HTML_DOCS=( doc/ )
	einstalldocs
}
