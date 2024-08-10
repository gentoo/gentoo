# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop toolchain-funcs

DESCRIPTION="Re-Write of the game Drug Wars"
HOMEPAGE="https://dopewars.sourceforge.io/"
SRC_URI="https://github.com/benmwebb/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls ncurses gtk gnome sdl"

RDEPEND="
	ncurses? ( >=sys-libs/ncurses-5.2:0= )
	gtk? ( x11-libs/gtk+:2 )
	dev-libs/glib:2
	nls? ( virtual/libintl )
	sdl? (
		media-libs/libsdl2
		media-libs/sdl2-mixer
	)
"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
"
BDEPEND="virtual/pkgconfig"

DOCS=( AUTHORS NEWS README.md TODO doc/example-cfg doc/example-igneous )

src_prepare() {
	default
	eautoreconf
	sed -i -e 's:index.html:html/index.html:' \
		src/dopewars.c || die
	sed -i -e "s/\-lncurses/$($(tc-getPKG_CONFIG) --libs ncurses)/g" \
		configure || die
}

src_configure() {
	local myservconf

	if ! use gtk ; then
		myservconf="--disable-gui-client --disable-gui-server --disable-glibtest --disable-gtktest"
	fi

	local myeconfargs=(
		$(use_enable ncurses curses-client)
		$(use_enable nls)
		$(use_with sdl)
		--without-esd
		--enable-networking
		--enable-plugins
		${myservconf}
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install
	rm -r "${ED}"/usr/share/gnome || die
	rm -r "${ED}"/usr/share/doc || die
	make_desktop_entry "${PN}" "Dopewars" /usr/share/pixmaps/dopewars-weed.png
	HTML_DOCS="doc/*html doc/help/"
	einstalldocs
}
