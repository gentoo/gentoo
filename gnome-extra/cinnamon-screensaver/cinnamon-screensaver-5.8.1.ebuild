# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10..11} )

inherit meson python-single-r1 xdg

DESCRIPTION="Screensaver for Cinnamon"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/ https://github.com/linuxmint/cinnamon-screensaver"
SRC_URI="https://github.com/linuxmint/cinnamon-screensaver/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2+ MIT"
SLOT="0"
IUSE="systemd xinerama"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

COMMON_DEPEND="
	${PYTHON_DEPS}
	>=dev-libs/glib-2.37.3:2[dbus]
	>=gnome-extra/cinnamon-desktop-5.8
	sys-libs/pam
	>=x11-libs/gtk+-3.22:3[introspection]
	x11-libs/cairo
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/pango
	x11-misc/xdotool
	x11-themes/adwaita-icon-theme

	xinerama? ( x11-libs/libXinerama )
"
RDEPEND="
	${COMMON_DEPEND}
	>=app-accessibility/caribou-0.3
	sys-apps/accountsservice[introspection]
	sys-process/procps
	x11-apps/xprop
	$(python_gen_cond_dep '
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/setproctitle[${PYTHON_USEDEP}]
		>=dev-python/python3-xapp-2.4.1[${PYTHON_USEDEP}]
	')

	systemd? ( >=sys-apps/systemd-31 )
	!systemd? ( sys-auth/elogind )
"
DEPEND="
	${COMMON_DEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	dev-util/gdbus-codegen
	sys-apps/dbus
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	default
	python_fix_shebang install-scripts src
}

src_configure() {
	local emesonargs=(
		$(meson_use xinerama)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	python_optimize "${ED}"/usr/share/cinnamon-screensaver/
}
