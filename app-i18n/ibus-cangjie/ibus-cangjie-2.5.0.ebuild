# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} )
inherit meson gnome2-utils python-r1 xdg

DESCRIPTION="Chinese Cangjie and Quick engines for IBus"
HOMEPAGE="https://cangjie.pages.freedesktop.org/projects/ibus-cangjie/"
SRC_URI="https://gitlab.freedesktop.org/cangjie/ibus-cangjie/-/jobs/67033920/artifacts/raw/builddir/meson-dist/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="nls"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	app-i18n/ibus[python(+),${PYTHON_USEDEP}]
	>=app-i18n/libcangjie-1.4.0
	>=dev-python/cangjie-1.5.0[${PYTHON_USEDEP}]
	media-libs/gsound[introspection]
	nls? ( virtual/libintl )
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-build/meson-1.3.2
	nls? ( sys-devel/gettext )
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.5.0-no-coverage.patch
)

src_configure() {
	python_foreach_impl meson_src_configure
}

src_compile() {
	python_foreach_impl meson_src_compile
}

src_test() {
	python_foreach_impl meson_src_test
}

src_install() {
	python_install() {
		meson_src_install
		python_optimize
	}
	python_foreach_impl python_install

	mv "${ED}"/usr/share/doc/ibus-cangjie "${ED}"/usr/share/doc/${PF} || die
}

pkg_preinst() {
	xdg_pkg_preinst
	gnome2_schemas_savelist
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
