# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit systemd toolchain-funcs

DESCRIPTION="Customizable and lightweight notification-daemon"
HOMEPAGE="https://dunst-project.org/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dunst-project/dunst"
else
	SRC_URI="https://github.com/dunst-project/dunst/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="test wayland"
RESTRICT="!test? ( test )"

DEPEND="
	dev-libs/glib:2
	sys-apps/dbus
	x11-libs/cairo[X,glib]
	x11-libs/gdk-pixbuf
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libnotify
	x11-libs/pango[X]
	wayland? ( dev-libs/wayland )
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-lang/perl
	virtual/pkgconfig
	wayland? ( dev-libs/wayland-protocols )
"

PATCHES=( "${FILESDIR}"/${PN}-1.6.1-no-Os.patch )

src_configure() {
	tc-export CC PKG_CONFIG
	default
}

src_compile() {
	emake WAYLAND=$(usex wayland 1 0) SYSTEMD=0
	sed -e "s|##PREFIX##|${EPREFIX}/usr|" \
	    -i dunst.systemd.service.in > dunst.service
}

src_install() {
	emake WAYLAND=$(usex wayland 1 0) SYSTEMD=0 \
	      DESTDIR="${D}" PREFIX="${EPREFIX}/usr" install
	systemd_dounit dunst.service
}
