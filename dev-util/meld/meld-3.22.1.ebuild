# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..12} )
PYTHON_REQ_USE="xml(+)"

inherit gnome.org gnome2-utils meson python-single-r1 xdg

DESCRIPTION="A graphical diff and merge tool"
HOMEPAGE="http://meldmerge.org/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	>=x11-libs/gtk+-3.20:3[introspection]
	>=dev-libs/glib-2.48:2
	>=x11-libs/gtksourceview-4.0.0:4[introspection]
	$(python_gen_cond_dep '
		>=dev-python/pygobject-3.30:3[cairo,${PYTHON_USEDEP}]
	')
	gnome-base/gsettings-desktop-schemas
	>=x11-libs/pango-1.34[introspection]
	x11-themes/hicolor-icon-theme
"
DEPEND="${RDEPEND}
	test? (
		dev-util/desktop-file-utils
		dev-libs/appstream-glib
	)
"
BDEPEND="
	dev-util/intltool
	dev-util/itstool
	sys-devel/gettext
	$(python_gen_cond_dep 'dev-python/distro[${PYTHON_USEDEP}]')
"
# dev-python/distro is soft-required in BDEPEND for python3.8 and onwards,
# but it's mainly needed for debian and derivatives - seems the fallback
# works fine, as we aren't a special_case, just an annoying warning.

pkg_setup() {
	python-single-r1_pkg_setup
}

src_configure() {
	local emesonargs=(
		-Dprofile=''
		-Dbyte-compile=false
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	python_optimize
	python_fix_shebang "${ED}"/usr/bin/meld
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
