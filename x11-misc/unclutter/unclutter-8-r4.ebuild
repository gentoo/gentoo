# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Hides mouse pointer while not in use"
HOMEPAGE="http://www.ibiblio.org/pub/X11/contrib/utilities/unclutter-8.README"
SRC_URI="ftp://ftp.x.org/contrib/utilities/${P}.tar.Z"

SLOT="0"
LICENSE="public-domain"
KEYWORDS="~alpha amd64 ~hppa ~mips ~ppc ppc64 ~sparc x86"

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-proto/xproto"

S=${WORKDIR}/${PN}

PATCHES=(
	"${FILESDIR}"/${P}-include.patch
	"${FILESDIR}"/${P}-FocusOut.patch
)

src_compile() {
	emake CDEBUGFLAGS="${CFLAGS}" CC="$(tc-getCC)" LDOPTIONS="${LDFLAGS}"
}

src_install () {
	dobin unclutter
	newman unclutter.man unclutter.1x
	einstalldocs
}
