# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8} )

inherit meson python-single-r1 xdg

DESCRIPTION="Screensaver for Cinnamon"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/"
SRC_URI="https://github.com/linuxmint/cinnamon-screensaver/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
IUSE="systemd xinerama"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
KEYWORDS="amd64 ~arm64 x86"

COMMON_DEPEND="
	>=dev-libs/glib-2.37.3:2[dbus]
	>=x11-libs/gtk+-3.22:3[introspection]
	>=gnome-extra/cinnamon-desktop-4.6:0=
	>=dev-libs/dbus-glib-0.78

	sys-apps/dbus
	sys-libs/pam
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXrandr
	x11-themes/adwaita-icon-theme

	${PYTHON_DEPS}

	xinerama? ( x11-libs/libXinerama )
"
RDEPEND="${COMMON_DEPEND}
	>=app-accessibility/caribou-0.3
	sys-apps/accountsservice[introspection]
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/setproctitle[${PYTHON_USEDEP}]
		dev-python/xapp[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
	')
	systemd? ( >=sys-apps/systemd-31 )
	!systemd? ( sys-auth/elogind )
"
DEPEND="${COMMON_DEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	dev-util/gdbus-codegen
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/${PN}-4.6.0-python-build.patch
	"${FILESDIR}"/${PN}-4.6.0-xinerama.patch
)

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
