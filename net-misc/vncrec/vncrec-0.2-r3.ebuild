# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="VNC session recorder and player"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="
	app-text/rman
	sys-devel/gcc
	x11-misc/gccmakedep
	>=x11-misc/imake-1.0.8-r1"

PATCHES=(
	"${FILESDIR}"/${P}-includes.patch
	"${FILESDIR}"/${P}-clang.patch
)

src_prepare() {
	default

	touch vncrec/vncrec.man || die
	sed -i '/make Makefiles/d' Imakefile || die
}

src_configure() {
	CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" \
		IMAKECPP="${IMAKECPP:-${CHOST}-gcc -E}" xmkmf -a || die
}

src_compile() {
	emake \
		AR="$(tc-getAR) cq" \
		CC="$(tc-getCC)" \
		RANLIB="$(tc-getRANLIB)" \
		CDEBUGFLAGS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}" \
		World
}
