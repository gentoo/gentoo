# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="A Machine Emulator, Mainly emulates MIPS, but supports other CPU types"
HOMEPAGE="http://gxemul.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/project/gxemul/GXemul/${PV}/${P}.tar.gz"

LICENSE="BSD public-domain"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~sparc ~x86"
IUSE="debug X"

RDEPEND="X? ( x11-libs/libX11 )"
DEPEND="
	${RDEPEND}
	X? ( x11-base/xorg-proto )
"
DOCS=( HISTORY README )
HTML_DOCS=( doc/. )

src_prepare() {
	default
	append-cflags -fgnu89-inline
	sed -i configure -e 's|-O3||g' || die
}

src_configure() {
	tc-export CC CXX
	# no autotools
	local myconfargs=(
		$(use debug && echo --debug)
		$(use X || echo --disable-x)
	)
	./configure "${myconfargs[@]}" || die
}

src_install() {
	dobin ${PN}
	doman man/${PN}.1
	einstalldocs
}
