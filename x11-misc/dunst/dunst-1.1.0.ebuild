# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="customizable and lightweight notification-daemon"
HOMEPAGE="http://www.knopwob.org/dunst/"
SRC_URI="http://www.knopwob.org/public/dunst-release/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="dunstify"

CDEPEND="
	dev-libs/glib:2
	dev-libs/libxdg-basedir
	sys-apps/dbus
	x11-libs/cairo[X,glib]
	x11-libs/gdk-pixbuf
	x11-libs/libXScrnSaver
	x11-libs/libXft
	x11-libs/libXinerama
	x11-libs/pango[X]
	dunstify? ( x11-libs/libnotify )
"
DEPEND="
	${CDEPEND}
	dev-lang/perl
	virtual/pkgconfig
"
RDEPEND="${CDEPEND}"

src_prepare() {
	sed -i \
		-e '/^CFLAGS/ { s:-g::; s:-O.:: }' \
		-e '/^CPPFLAGS/ s:-D_BSD_SOURCE:-D_DEFAULT_SOURCE:' \
		config.mk || die

	sed -i \
		-e 's:registration_id > 0:(&):' \
		dbus.c || die

	sed -i \
		-e '/g_print.*iter->data/ s:iter->data:(char *)&:' \
		dunstify.c || die

	default
}

src_compile() {
	tc-export CC
	emake V=

	use dunstify && emake V= dunstify
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install

	if use dunstify; then
		dobin dunstify
	fi

	dodoc CHANGELOG
}
