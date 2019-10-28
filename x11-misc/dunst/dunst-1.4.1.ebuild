# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Customizable and lightweight notification-daemon"
HOMEPAGE="https://dunst-project.org/ https://github.com/dunst-project/dunst"
SRC_URI="https://github.com/${PN}-project/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="dunstify"

CDEPEND="
	dev-libs/glib:2
	sys-apps/dbus
	x11-libs/cairo[X,glib]
	x11-libs/gdk-pixbuf
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXinerama
	x11-libs/libXrandr
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
	sed -i -e "/^CFLAGS/ { s:-g::;s:-O.:: }" config.mk || die

	default
}

src_compile() {
	tc-export CC
	emake
	use dunstify && emake dunstify
}

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" install

	use dunstify && dobin dunstify

	dodoc AUTHORS CHANGELOG.md README.md RELEASE_NOTES
}
