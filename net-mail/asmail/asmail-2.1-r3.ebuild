# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="A small mail monitor similar to xbiff"
HOMEPAGE="https://tigr.net/afterstep/applets/"
SRC_URI="https://tigr.net/afterstep/download/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="jpeg"

RDEPEND="
	dev-libs/openssl:0=
	x11-libs/libXext
	x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libICE
	x11-libs/libSM
	jpeg? ( media-libs/libjpeg-turbo:0 )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

PATCHES=(
	"${FILESDIR}"/${P}-update-autotools.patch
)

src_prepare() {
	default
	cd "${S}/autoconf" || die
	eautoreconf
	cp "${S}/autoconf/configure" "${S}/" || die
}

src_configure() {
	tc-export CC
	econf $(use_enable jpeg) --with-xpm-library=/usr/$(get_libdir)
}

src_install() {
	dobin ${PN}

	newman ${PN}.man ${PN}.1
	newman ${PN}rc.man ${PN}rc.5

	insinto /usr/share/${PN}/pixmaps
	doins pixmaps/cloud-e/*.xpm

	insinto /usr/share/${PN}
	doins -r sounds

	dodoc ${PN}rc.s* CHANGES *.txt README* TODO
}
