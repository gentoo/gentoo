# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="GUI frontend to xmodmap"
HOMEPAGE="http://packages.qa.debian.org/x/xkeycaps.html"
SRC_URI="mirror://debian/pool/main/x/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="x11-misc/xbitmaps
	x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXaw
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-misc/imake
	>=sys-apps/sed-4"

DOCS=( README defining.txt hierarchy.txt sgi-microsoft.txt )
PATCHES=(
	"${FILESDIR}"/${P}-Imakefile.patch
	"${FILESDIR}"/${P}-man.patch
)

src_compile() {
	xmkmf || die
	sed -i -e "s,all:: xkeycaps.\$(MANSUFFIX).html,all:: ,g" \
		Makefile || die
	emake EXTRA_LDOPTIONS="${LDFLAGS}" CC="$(tc-getCC)" \
		CDEBUGFLAGS="${CFLAGS}"
}

src_install () {
	default
	newman ${PN}.man ${PN}.1
}
