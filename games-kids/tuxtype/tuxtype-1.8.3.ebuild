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
IUSE="svg"

DEPEND="acct-group/gamestat
	media-libs/libsdl[video]
	media-libs/sdl-image
	media-libs/sdl-mixer
	media-libs/sdl-pango
	media-libs/sdl-ttf
	svg? ( gnome-base/librsvg:2 )"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-upstream-${PV}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.8.3-games-group.patch
)

src_prepare() {
	xdg_src_prepare
	eautoreconf
}

src_configure() {
	econf \
		--localedir="${EPREFIX}"/usr/share/locale \
		$(use_with svg rsvg)
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
