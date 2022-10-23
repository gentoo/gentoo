# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Fly about 3D-formed file system"
HOMEPAGE="http://xcruiser.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
RESTRICT="test"

RDEPEND="x11-libs/libXaw"
DEPEND="${RDEPEND}"
BDEPEND="
	app-text/rman
	sys-devel/gcc
	x11-misc/gccmakedep
	>=x11-misc/imake-1.0.8-r1"

src_configure() {
	CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" \
		IMAKECPP="${IMAKECPP:-${CHOST}-gcc -E}" xmkmf -a || die
}

src_compile() {
	local myemakeargs=(
		CC="$(tc-getCC)"
		CDEBUGFLAGS="${CFLAGS}"
		LOCAL_LDFLAGS="${LDFLAGS}"
	)
	emake "${myemakeargs[@]}"
}

src_install() {
	dobin xcruiser
	newman xcruiser.man xcruiser.1
	einstalldocs
}
