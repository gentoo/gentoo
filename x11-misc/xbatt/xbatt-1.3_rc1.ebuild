# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs eapi7-ver

MY_PV=${PV/_rc/pr}
DESCRIPTION="Notebook battery indicator for X"
HOMEPAGE="http://www.clave.gr.jp/~eto/xbatt/"
SRC_URI="http://www.clave.gr.jp/~eto/xbatt/${PN}-${MY_PV}.tar.gz"

LICENSE="xbatt"
SLOT="0"
KEYWORDS="amd64 ppc x86"
RDEPEND="
	x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXaw
	x11-libs/libXext
	x11-libs/libxkbfile
	x11-libs/libXpm
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
	>=x11-misc/imake-1.0.8-r1
"
PATCHES=(
	"${FILESDIR}"/${PN}-1.2.1-implicits.patch
)
S="${WORKDIR}"/${PN}-$(ver_cut 1-2)

src_configure() {
	CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" \
		IMAKECPP="${IMAKECPP:-$(tc-getCPP)}" xmkmf || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CDEBUGFLAGS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}" \
		xbatt
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README*
}
