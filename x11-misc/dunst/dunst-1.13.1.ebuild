# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd toolchain-funcs

DESCRIPTION="Lightweight replacement for common notification daemons"
HOMEPAGE="https://dunst-project.org/ https://github.com/dunst-project/dunst"
SRC_URI="https://github.com/dunst-project/dunst/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="+completions +dunstify wayland +X +xdg"

DEPEND="
	dev-libs/glib:2
	sys-apps/dbus
	x11-libs/cairo[X?,glib]
	x11-libs/gdk-pixbuf:2
	x11-libs/pango[X?]
	dunstify? ( x11-libs/libnotify )
	wayland? ( dev-libs/wayland )
	X? (
		x11-libs/libX11
		x11-libs/libXext
		x11-libs/libXScrnSaver
		x11-libs/libXinerama
		x11-libs/libXrandr
	)
	xdg? ( x11-misc/xdg-utils )
"

RDEPEND="${DEPEND}"

BDEPEND="
	dev-lang/perl
	virtual/pkgconfig
	wayland? ( dev-libs/wayland-protocols )
"

REQUIRED_USE="|| ( wayland X )"

src_prepare() {
	default

	# Respect users CFLAGS
	sed -e 's/-Os//' -i config.mk || die

	# Use correct path for dbus and system unit
	sed -e "s|@bindir@|${EPREFIX}/usr/bin|" -i dunst.systemd.service.in || die
	sed -e "s|@bindir@|${EPREFIX}/usr/bin|" -i org.knopwob.dunst.service.in || die
}

src_configure() {
	tc-export CC PKG_CONFIG

	default
}

src_compile() {
	local myemakeargs=(
		DUNSTIFY="$(usex dunstify 1 0)"
		SYSCONFDIR="${EPREFIX}/etc/xdg"
		SYSTEMD="0"
		WAYLAND="$(usex wayland 1 0)"
		X11="$(usex X 1 0)"
	)

	emake "${myemakeargs[@]}"
}

src_install() {
	local myemakeargs=(
		COMPLETIONS="$(usex completions 1 0)"
		DUNSTIFY="$(usex dunstify 1 0)"
		PREFIX="${ED}/usr"
		SYSCONFDIR="${ED}/etc/xdg"
		SYSTEMD="0"
		WAYLAND="$(usex wayland 1 0)"
		X11="$(usex X 1 0)"
	)

	emake "${myemakeargs[@]}" install

	exeinto /etc/user/init.d
	newexe "${FILESDIR}/dunst.initd" dunst
	systemd_newuserunit dunst.systemd.service.in dunst.service
}
