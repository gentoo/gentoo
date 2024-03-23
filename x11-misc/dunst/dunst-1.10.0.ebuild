# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit shell-completion systemd toolchain-funcs

DESCRIPTION="Lightweight replacement for common notification daemons"
HOMEPAGE="https://dunst-project.org/ https://github.com/dunst-project/dunst"
SRC_URI="https://github.com/dunst-project/dunst/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="wayland"

DEPEND="
	dev-libs/glib:2
	sys-apps/dbus
	x11-libs/cairo[X,glib]
	x11-libs/gdk-pixbuf:2
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXScrnSaver
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libnotify
	x11-libs/pango[X]
	x11-misc/xdg-utils
	wayland? ( dev-libs/wayland )
"

RDEPEND="${DEPEND}"

BDEPEND="
	dev-lang/perl
	virtual/pkgconfig
	wayland? ( dev-libs/wayland-protocols )
"

src_prepare() {
	default

	# Respect users CFLAGS
	sed -e 's/-Os//' -i config.mk || die

	# Use correct path for dbus and system unit
	sed -e "s|##PREFIX##|${EPREFIX}/usr|" -i dunst.systemd.service.in || die
	sed -e "s|##PREFIX##|${EPREFIX}/usr|" -i org.knopwob.dunst.service.in || die
}

src_configure() {
	tc-export CC PKG_CONFIG

	default
}

src_compile() {
	local myemakeargs=(
		SYSCONFDIR="${EPREFIX}/etc/xdg"
		SYSTEMD="0"
		WAYLAND="$(usex wayland 1 0)"
	)

	emake "${myemakeargs[@]}"
}

src_install() {
	local myemakeargs=(
		PREFIX="${ED}/usr"
		SYSCONFDIR="${ED}/etc/xdg"
		SYSTEMD="0"
		WAYLAND="$(usex wayland 1 0)"
	)

	emake "${myemakeargs[@]}" install

	newbashcomp contrib/dunst.bashcomp dunst
	newbashcomp contrib/dunstctl.bashcomp dunstctl
	newfishcomp contrib/dunst.fishcomp dunst
	newfishcomp contrib/dunstctl.fishcomp dunstctl
	newfishcomp contrib/dunstify.fishcomp dunstify
	newzshcomp contrib/_dunst.zshcomp _dunst
	newzshcomp contrib/_dunstctl.zshcomp _dunstctl

	systemd_newuserunit dunst.systemd.service.in dunst.service
}
