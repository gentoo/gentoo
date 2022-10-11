# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Simple hex calculator for X"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.Z"
S="${WORKDIR}/${PN}"

LICENSE="HPND"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXt"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="
	app-text/rman
	sys-devel/gcc
	>=x11-misc/imake-1.0.8-r1"

PATCHES=(
	"${FILESDIR}"/${PN}-keypad.diff
	"${FILESDIR}"/${PN}-order.diff
)

src_configure() {
	append-cflags -std=gnu89 # old codebase, incompatible with c2x

	CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" \
		IMAKECPP="${IMAKECPP:-${CHOST}-gcc -E}" xmkmf || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		CCLINK="$(tc-getCC)" \
		LDOPTIONS="${LDFLAGS}"
}

src_install() {
	dobin ${PN}
	newman ${PN}.{man,1}
}
