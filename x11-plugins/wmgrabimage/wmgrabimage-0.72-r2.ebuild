# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

MY_PN=${PN/grabi/GrabI}

DESCRIPTION="wmGrabImage grabs an image from the WWW and displays it"
HOMEPAGE="https://www.dockapps.net/wmgrabimage"
SRC_URI="https://www.dockapps.net/download/${MY_PN}-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

RDEPEND=">=net-misc/wget-1.9-r2
	>=media-gfx/imagemagick-5.5.7.15
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

S=${WORKDIR}/${MY_PN}-${PV}/${MY_PN}

PATCHES=( "${FILESDIR}"/${PN}-noman.patch )

src_prepare() {
	sed -i -e 's/-geom /-geometry /' GrabImage || die
	sed -i -e 's/install -s -m /install -m /' Makefile || die
	default

	pushd "${WORKDIR}"/${MY_PN}-${PV} || die
	eapply "${FILESDIR}"/${P}-gcc-10.patch
}

src_compile() {
	emake clean
	emake CFLAGS="${CFLAGS} -Wall" SYSTEM="${LDFLAGS}"
}

src_install() {
	dodir /usr/bin
	emake DESTDIR="${D}/usr" install

	doman wmGrabImage.1
	domenu "${FILESDIR}"/${PN}.desktop
	dodoc ../{BUGS,CHANGES,HINTS,TODO}
}
