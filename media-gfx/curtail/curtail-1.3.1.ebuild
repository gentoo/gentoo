# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )

inherit gnome2-utils meson python-single-r1 xdg

DESCRIPTION="Image compressor, supporting PNG, JPEG and WebP"
HOMEPAGE="https://github.com/Huluti/Curtail/"
SRC_URI="https://github.com/Huluti/${PN^}/archive/${PV}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${P^}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="test"  # Just desktop / schema / appstream file validation (fails).

RDEPEND="
	${PYTHON_DEPS}
	>=x11-libs/gtk+-3.20:3[introspection]
	$(python_gen_cond_dep 'dev-python/pygobject:3[${PYTHON_USEDEP}]')
"
BDEPEND="
	${RDEPEND}
	dev-libs/appstream-glib
	dev-util/desktop-file-utils
"
RDEPEND+="
	media-gfx/jpegoptim
	media-gfx/optipng
	media-gfx/pngquant
	media-libs/libwebp
"

DOCS=( CHANGELOG.md README.md )

src_prepare() {
	sed -i "s|@PYTHON@|${PYTHON}|" "${S}"/src/${PN}.in || die

	default
}

src_install() {
	meson_src_install
	python_optimize
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
