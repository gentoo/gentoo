# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit meson gnome2-utils python-single-r1

DESCRIPTION="Cinnamon session manager"
HOMEPAGE="https://projects.linuxmint.com/cinnamon/ https://github.com/linuxmint/cinnamon-session"
SRC_URI="https://github.com/linuxmint/cinnamon-session/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="systemd"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="
	>=dev-libs/glib-2.37.3:2
	>=gnome-extra/cinnamon-desktop-6.2:0=
	media-libs/libcanberra[pulseaudio]
	virtual/opengl
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3:3[introspection]
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXcomposite
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/pango[X]
	>=x11-libs/xapp-2.8.4[introspection]

	systemd? (
		>=sys-apps/systemd-183
	)
	!systemd? (
		sys-auth/elogind[policykit]
	)
"
DEPEND="
	${COMMON_DEPEND}
	x11-libs/xtrans
"
RDEPEND="
	${COMMON_DEPEND}
	${PYTHON_DEPS}
	dev-libs/gobject-introspection
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/setproctitle[${PYTHON_USEDEP}]
	')
"
BDEPEND="
	${PYTHON_DEPS}
	dev-util/gdbus-codegen
	virtual/pkgconfig
"

src_prepare() {
	default
	python_fix_shebang data cinnamon-session-quit
}

src_configure() {
	local emesonargs=(
		-Dipv6=true
		-Dxtrans=true
	)
	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_icon_cache_update
	gnome2_schemas_update
}
