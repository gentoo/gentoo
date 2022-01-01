# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_REQ_USE="xml"
PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_SETUPTOOLS=no

inherit gnome2 distutils-r1

DESCRIPTION="A graphical diff and merge tool"
HOMEPAGE="http://meldmerge.org/"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.50:2
	$(python_gen_cond_dep '
		>=dev-python/pygobject-3.12:3[cairo,${PYTHON_MULTI_USEDEP}]
	')
	gnome-base/gsettings-desktop-schemas
	>=x11-libs/gtk+-3.20:3[introspection]
	>=x11-libs/gtksourceview-3.20.0:3.0[introspection]
	>=x11-libs/pango-1.34[introspection]
	x11-themes/hicolor-icon-theme
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	dev-util/itstool
	sys-devel/gettext
"
# dev-python/distro is soft-required in BDEPEND for python3.8 and onwards,
# but it's mainly needed for debian and derivatives - seems the fallback
# works fine, as we aren't a special_case, just an annoying warning.

python_compile_all() {
	mydistutilsargs=( --no-update-icon-cache --no-compile-schemas )
}

python_install() {
	local mydistutilsargs=( --no-update-icon-cache --no-compile-schemas build )
	distutils-r1_python_install
	rm "${ED}"/usr/share/doc/meld-${PV}/{COPYING,NEWS} || die
	rmdir "${ED}"/usr/share/doc/meld-${PV} || die
}
