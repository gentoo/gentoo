# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 shell-completion systemd toolchain-funcs

EGIT_REPO_URI="https://github.com/dunst-project/dunst"

DESCRIPTION="Lightweight replacement for common notification daemons"
HOMEPAGE="https://dunst-project.org/ https://github.com/dunst-project/dunst"

LICENSE="BSD"
SLOT="0"
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

	# Use correct path for system unit
	sed -e "s|##PREFIX##|${EPREFIX}/usr|" -i dunst.systemd.service.in || die
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

	newbashcomp completions/dunst.bashcomp dunst
	newbashcomp completions/dunstctl.bashcomp dunstctl
	newfishcomp completions/dunst.fishcomp dunst
	newfishcomp completions/dunstctl.fishcomp dunstctl
	newfishcomp completions/dunstify.fishcomp dunstify
	newzshcomp completions/_dunst.zshcomp _dunst
	newzshcomp completions/_dunstctl.zshcomp _dunstctl

	systemd_newuserunit dunst.systemd.service.in dunst.service
}
