# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils toolchain-funcs

MY_P=wmMand-${PV}

DESCRIPTION="a dockable mandelbrot browser"
HOMEPAGE="https://sourceforge.net/projects/wmmand/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

S=${WORKDIR}/${MY_P}/wmMand

DOCS=( ../{BUGS,changelog,TODO} )

src_prepare() {
	default
	gunzip wmMand.6.gz || die

	pushd "${WORKDIR}"/${MY_P} || die
	eapply "${FILESDIR}"/${P}-gcc-10.patch
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" \
		SYSTEM="${LDFLAGS}" \
		INCDIR="" LIBDIR=""
}

src_install() {
	dobin wmMand
	doman wmMand.6
	doicon wmMand.png
	einstalldocs
}
