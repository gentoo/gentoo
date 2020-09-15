# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A Machine Emulator, Mainly emulates MIPS, but supports other CPU types"
HOMEPAGE="http://gxemul.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/gxemul/GXemul/${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~sparc ~x86"
IUSE="debug X"

RDEPEND="X? ( x11-libs/libX11 )"
DEPEND="${RDEPEND}
	X? ( x11-base/xorg-proto )"

PATCHES=(
	"${FILESDIR}"/${PN}-0.6.0-gcc46.patch
	"${FILESDIR}"/${P}-fix-mymkstemp.patch # Bug 441558
	"${FILESDIR}"/${P}-fix-mkstemp-test.patch # Bug 441558
	"${FILESDIR}"/${PN}-0.6.0-no-doxygen.patch
)

src_prepare() {
	default

	sed -i configure -e 's|-O3||g' || die "sed configure"
	tc-export CC CXX
}

src_configure() {
	# no autotools
	./configure \
		--disable-valgrind \
		$(use debug && echo --debug) \
		$(use X || echo --disable-x) \
	|| die "configure failed"
}

src_install() {
	dobin gxemul
	doman man/gxemul.1
	dodoc HISTORY README
	docinto html
	dodoc -r doc/.
}
