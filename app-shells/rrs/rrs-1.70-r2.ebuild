# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Reverse Remote Shell"
HOMEPAGE="http://freecode.com/projects/rrs"
SRC_URI="http://www.cycom.se/uploads/36/19/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86"

IUSE="ssl"

DEPEND="ssl? ( dev-libs/openssl:0= )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-asneeded.patch"
	"${FILESDIR}/${P}-drop-old-ssl-algos.patch"
)

src_prepare() {
	default
	sed -i -e "s#-s ##g" Makefile || die
}

src_compile() {
	local target=""
	use ssl || target="-nossl"

	emake generic${target} CFLAGS="${CFLAGS}" LDEXTRA="${LDFLAGS}" CC="$(tc-getCC)"
}

src_install() {
	dobin "${PN}"
	doman "${PN}.1"
	einstalldocs
}
