# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools desktop xdg

DESCRIPTION="Typing tutorial with lots of eye-candy"
HOMEPAGE="https://github.com/tux4kids/tuxtype"
SRC_URI="https://github.com/tux4kids/${PN}/archive/upstream/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+pango svg"

DEPEND="acct-group/gamestat
	dev-games/t4k-common
	media-libs/libsdl[video]
	media-libs/sdl-image
	media-libs/sdl-mixer
	!pango? ( media-libs/sdl-ttf )
	pango? ( media-libs/sdl-pango )
	svg? ( gnome-base/librsvg:2 )"

RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/${PN}-upstream-${PV}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.8.3-games-group.patch
)

src_prepare() {
	xdg_src_prepare

	# Fix broken linkage due to incorrect variable casing.
	sed -i 's:$SDL_TTF:$SDL_ttf:g' configure.ac || die

	eautoreconf
}

src_configure() {
	econf \
		--localedir="${EPREFIX}"/usr/share/locale \
		$(use_with pango sdlpango) \
		$(use_with svg rsvg) \
		--without-sdlnet # Unused!
}

src_install() {
	emake install DESTDIR="${D}"
	rm -v "${ED}"/usr/share/doc/${PF}/{ABOUT-NLS,COPYING,INSTALL} || die
	keepdir /etc/${PN} /var/lib/${PN}/words

	newicon -s 64 icon.png ${PN}.png
	make_desktop_entry ${PN} TuxTyping

	fowners root:gamestat /var/lib/${PN} /usr/bin/${PN}
	fperms 660 /var/lib/${PN}
	fperms 2755 /usr/bin/${PN}
}
