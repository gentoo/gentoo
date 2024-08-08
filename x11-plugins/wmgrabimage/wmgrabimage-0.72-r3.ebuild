# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

MY_PN="${PN/grabi/GrabI}"

DESCRIPTION="wmGrabImage grabs an image from the WWW and displays it"
HOMEPAGE="https://www.dockapps.net/wmgrabimage"
SRC_URI="https://www.dockapps.net/download/${MY_PN}-${PV}.tgz"
S="${WORKDIR}/${MY_PN}-${PV}/${MY_PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=net-misc/wget-1.9-r2
	>=media-gfx/imagemagick-5.5.7.15
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

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
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS} -Wall" SYSTEM="${LDFLAGS}"
}

src_install() {
	dodir /usr/bin
	emake DESTDIR="${D}/usr" install

	doman wmGrabImage.1
	domenu "${FILESDIR}"/${PN}.desktop
	dodoc ../{BUGS,CHANGES,HINTS,TODO}
}
