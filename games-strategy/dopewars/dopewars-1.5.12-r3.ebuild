# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop toolchain-funcs

DESCRIPTION="Re-Write of the game Drug Wars"
HOMEPAGE="http://dopewars.sourceforge.net/"
SRC_URI="mirror://sourceforge/dopewars/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls ncurses gtk gnome sdl"

RDEPEND="
	ncurses? ( >=sys-libs/ncurses-5.2:0= )
	gtk? ( x11-libs/gtk+:2 )
	dev-libs/glib:2
	nls? ( virtual/libintl )
	sdl? (
		media-libs/libsdl
		media-libs/sdl-mixer
	)
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

src_prepare() {
	default
	eapply "${FILESDIR}"/${P}-CVE-2009-3591.patch
	sed -i \
		-e "/priv_hiscore/ s:DPDATADIR:\"/var/lib\":" \
		-e "/\/doc\// s:DPDATADIR:\"/usr/share\":" \
		-e 's:index.html:html/index.html:' \
		src/dopewars.c || die
	sed -i -e "s/\-lncurses/$($(tc-getPKG_CONFIG) --libs ncurses)/g" \
		configure || die
}

src_configure() {
	local myservconf

	if ! use gtk ; then
		myservconf="--disable-gui-client --disable-gui-server --disable-glibtest --disable-gtktest"
	fi

	econf \
		$(use_enable ncurses curses-client) \
		$(use_enable nls) \
		$(use_with sdl) \
		--without-esd \
		--enable-networking \
		--enable-plugins \
		${myservconf}
}

src_install() {
	emake DESTDIR="${D}" install
	rm -r "${ED}"/usr/share/gnome || die
	rm -rf "${ED}"/usr/share/doc
	make_desktop_entry "${PN}" "Dopewars" /usr/share/pixmaps/dopewars-weed.png
	HTML_DOCS="doc/*html" einstalldocs
}
