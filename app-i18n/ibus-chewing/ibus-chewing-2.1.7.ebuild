# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson gnome2-utils virtualx

DESCRIPTION="Chinese Chewing engine for IBus"
HOMEPAGE="https://github.com/chewing/ibus-chewing"
SRC_URI="https://github.com/chewing/ibus-chewing/releases/download/v${PV}/${P}-Source.tar.xz"

S="${WORKDIR}/${P}-Source"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=app-i18n/ibus-1.5.4
	>=app-i18n/libchewing-0.9.0
	dev-libs/glib:2
	gui-libs/libadwaita:1
	gui-libs/gtk:4
	virtual/libintl"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	sys-devel/gettext"

PATCHES=(
	"${FILESDIR}/ibus-chewing-2.1.7_docdir.patch"
)

src_test() {
	"${BROOT}${GLIB_COMPILE_SCHEMAS}" src/setup --targetdir="${BUILD_DIR}" || die

	export GSETTINGS_BACKEND="memory"
	export GSETTINGS_SCHEMA_DIR="${BUILD_DIR}"
	virtx meson_src_test -j1
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	xdg_icon_cache_update
}

pkg_postrm() {
	gnome2_schemas_update
	xdg_icon_cache_update
}
