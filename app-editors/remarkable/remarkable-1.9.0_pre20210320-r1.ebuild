# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit desktop gnome2-utils python-single-r1 readme.gentoo-r1

DESCRIPTION="Fully featured markdown editor, supports github markdown dialect"
HOMEPAGE="https://remarkableapp.github.io/ https://github.com/jamiemcg/remarkable"
GIT_COMMIT="7b0b3dacef270a00c28e8852a88d74f72a3544d7"
SRC_URI="https://github.com/jamiemcg/remarkable/archive/${GIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/Remarkable-${GIT_COMMIT}"

LICENSE="BSD-2 GPL-2+ LGPL-2.1+ MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	${PYTHON_DEPS}
	net-libs/webkit-gtk:4[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/gtksourceview:3.0[introspection]
	$(python_gen_cond_dep '
		dev-python/beautifulsoup4[${PYTHON_USEDEP}]
		dev-python/pycairo[${PYTHON_USEDEP}]
		dev-python/pygobject[${PYTHON_USEDEP}]
		dev-python/markdown[${PYTHON_USEDEP}]
	')"
RDEPEND="${DEPEND}"
PATCHES=( "${FILESDIR}"/${P}-disable-spellcheck.patch )

src_prepare() {
	default
	sed -i -e "s|import styles|from remarkable import styles|" \
		-e "s|from findBar|from remarkable.findBar|" \
		remarkable/RemarkableWindow.py || die
}

src_install() {
	default

	python_domodule markdown pdfkit remarkable remarkable_lib
	python_doscript bin/remarkable
	doicon data/ui/remarkable.png
	domenu ${PN}.desktop

	insinto /usr/share/${PN}
	doins -r data/ui
	doins -r data/media

	insinto /usr/share/glib-2.0/schemas
	doins data/glib-2.0/schemas/*

	readme.gentoo_create_doc
}

pkg_postinst() {
	gnome2_schemas_update
	readme.gentoo_print_elog
}

pkg_postrm() {
	gnome2_schemas_update
}
