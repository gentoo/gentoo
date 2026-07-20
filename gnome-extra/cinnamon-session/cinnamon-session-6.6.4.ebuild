# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..14} )

inherit meson gnome2-utils python-single-r1

DESCRIPTION="Cinnamon session manager"
HOMEPAGE="https://linuxmint-developer-guide.readthedocs.io/en/latest/cinnamon.html https://linuxmint.com/"
SRC_URI="https://github.com/linuxmint/cinnamon-session/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+ LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="systemd"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

COMMON_DEPEND="
	>=dev-libs/glib-2.37.3:2
	>=gnome-extra/cinnamon-desktop-6.6:0=
	media-libs/libcanberra[pulseaudio]
	virtual/opengl
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	>=x11-libs/gtk+-3:3[introspection,X]
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXcomposite
	x11-libs/libXext
	x11-libs/libXrender
	x11-libs/libXtst
	x11-libs/pango[X]
	>=x11-libs/xapp-3.2.2[introspection]

	systemd? (
		>=sys-apps/systemd-253
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
	>=dev-libs/gobject-introspection-1.82.0-r2
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/setproctitle[${PYTHON_USEDEP}]
	')
	x11-themes/xapp-symbolic-icon-theme
"
BDEPEND="
	${PYTHON_DEPS}
	>=dev-util/gdbus-codegen-2.80.5-r1
	virtual/pkgconfig
"

PATCHES=(
	# pkg-config variable systemduserunitdir belongs to package systemd.
	# https://github.com/linuxmint/cinnamon-session/commit/b7ac3041a00deec62c8d9f55ee33e139e8deb664
	"${FILESDIR}/${PN}-${PV}-fix-systemd-dep.patch"
)

src_prepare() {
	default
	python_fix_shebang data cinnamon-session-quit
}

src_configure() {
	local emesonargs=(
		-Dipv6=true
		-Dxtrans=true
		$(meson_feature systemd)
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
