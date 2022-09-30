# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs

DESCRIPTION="Shows currently transmitting beacons of the International Beacon Project (IBP)"
HOMEPAGE="http://www.pa3fwm.nl/software/ibp/"
SRC_URI="http://www.pa3fwm.nl/software/ibp/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="X"

RDEPEND="sys-libs/ncurses:0=
	X? ( x11-libs/libX11  )"
DEPEND="${RDEPEND}
	X? ( >=x11-misc/imake-1.0.8-r1 )"
BDEPEND="
	virtual/pkgconfig
	X? ( sys-devel/gcc )"

PATCHES=(
	"${FILESDIR}"/${P}-clang16.patch
)

src_prepare() {
	default

	# Respect CFLAGS if built without USE=X
	sed -i -e "s/= -D/+= -D/" Makefile || die

	# Fix compile if ncurses is built with separate libtinfo
	sed -i -e "s:-lcurses:$($(tc-getPKG_CONFIG) --libs ncurses):" Imakefile Makefile || die
}

src_configure() {
	if use X ;then
		CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" \
			IMAKECPP="${IMAKECPP:-${CHOST}-gcc -E}" xmkmf || die
	fi
}

src_compile() {
	if use X ; then
		emake \
			CC="$(tc-getCC)" \
			LOCAL_LDFLAGS="${LDFLAGS}" \
			CDEBUGFLAGS="${CFLAGS}"
	else
		emake CC="$(tc-getCC)"
	fi
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
}
