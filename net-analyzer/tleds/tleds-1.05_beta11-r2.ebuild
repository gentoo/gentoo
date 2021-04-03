# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="${P/_/}"
DESCRIPTION="Blinks keyboard LEDs indicating outgoing and incoming network packets on selected network interface"
HOMEPAGE="http://www.hut.fi/~jlohikos/tleds_orig.html"
SRC_URI="
	http://www.hut.fi/~jlohikos/tleds/public/${MY_P/11/10}.tgz
	http://www.hut.fi/~jlohikos/tleds/public/${MY_P}.patch.bz2
"
S="${WORKDIR}/${MY_P/eta11/}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="X"

DEPEND="X? ( x11-libs/libX11 )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${WORKDIR}"/${MY_P}.patch
	"${FILESDIR}"/${P}-gentoo.patch
)

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		$(usex X all tleds)
}

src_install() {
	dosbin tleds
	use X && dosbin xtleds

	doman tleds.1
	dodoc README Changes

	newinitd "${FILESDIR}"/tleds.init.d tleds
	newconfd "${FILESDIR}"/tleds.conf.d tleds
}
