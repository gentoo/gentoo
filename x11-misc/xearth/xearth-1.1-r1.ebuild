# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Set the X root window to an image of the Earth"
HOMEPAGE="https://hewgill.com/xearth/original/"
SRC_URI="ftp://cag.lcs.mit.edu/pub/tuna/${P}.tar.gz
	ftp://ftp.cs.colorado.edu/users/tuna/${P}.tar.gz"

LICENSE="xearth"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXt"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="
	app-text/rman
	sys-devel/gcc
	>=x11-misc/imake-1.0.8-r1"

PATCHES=(
	"${FILESDIR}"/${P}-include.patch
)

DOCS=( BUILT-IN GAMMA-TEST HISTORY README )

src_configure() {
	append-cflags -std=gnu89 # old codebase, incompatible with c2x

	CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" \
		IMAKECPP="${IMAKECPP:-${CHOST}-gcc -E}" xmkmf || die
}

src_compile() {
	local myemakeargs=(
		CC="$(tc-getCC)"
		CDEBUGFLAGS="${CFLAGS}"
		EXTRA_LDOPTIONS="${LDFLAGS}"
	)
	emake "${myemakeargs[@]}"
}

src_install() {
	dobin xearth
	newman xearth.man xearth.1
	einstalldocs
}
