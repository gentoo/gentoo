# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop xdg-utils

DESCRIPTION="Bomberman clone with network game support"
HOMEPAGE="https://www.bomberclone.de/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc64 ~x86"

DEPEND=">=media-libs/libsdl-1.1.0[video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[mod]"

RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.11.8-gcc52.patch
)

src_prepare() {
	default

	mv -v configure.{in,ac} || die
	sed -i 's/configure\.in/configure.ac/g' configure.ac || die
	eautoreconf
}

src_configure() {
	LIBS="-lm" \
	econf \
		--disable-werror \
		--without-x
}

src_install() {
	emake \
		DESTDIR="${D}" \
		bomberclonedocdir=\${prefix}/share/doc/${PF} \
		install

	doicon -s 64 data/pixmaps/${PN}.png
	make_desktop_entry ${PN} Bomberclone

	# Delete useless documentation.
	rm -v "${ED}"/usr/share/doc/${PF}/{COPYING,INSTALL,*.nsi} || die
}

pkg_postinst() { xdg_icon_cache_update; }
pkg_postrm() { xdg_icon_cache_update; }
