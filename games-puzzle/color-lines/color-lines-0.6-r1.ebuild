# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit desktop

DESCRIPTION="Color lines game written with SDL with bonus features"
HOMEPAGE="https://github.com/OpenA/color-lines-sdl"
SRC_URI="https://dev.gentoo.org/~pinkbyte/distfiles/snapshots/${P}.tar.gz -> lines_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux"

RDEPEND="
	media-libs/libsdl[X,sound,video]
	media-libs/sdl-image[png]
	media-libs/sdl-mixer[wav,mod]
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/lines-${PV}"

src_prepare() {
	default
	eapply "${FILESDIR}/${P}-Makefile.patch"

	sed -i \
		-e '/^Encoding/d' \
		-e '/^Version/d' \
		-e '/^Icon/s/.png//' \
		color-lines.desktop.in || die 'sed on color-lines.desktop.in failed'
}

src_compile() {
	emake BINDIR="${EPREFIX}/usr/bin/" GAMEDATADIR="${EPREFIX}/usr/share/${PN}/"
}

src_install() {
	insinto "/usr/share/${PN}"
	doins -r gfx sounds

	domenu ${PN}.desktop
	doicon icon/${PN}.png
	einstalldocs
	dobin ${PN}
}
