# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9} )
PYTHON_REQ_USE="sqlite"
DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_SETUPTOOLS=no
inherit distutils-r1 virtualx xdg

DESCRIPTION="A desktop wiki"
HOMEPAGE="
	https://zim-wiki.org/
	https://github.com/zim-desktop-wiki/zim-desktop-wiki
"
SRC_URI="https://github.com/${PN}-desktop-wiki/${PN}-desktop-wiki/archive/${PV/_/-}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~x86"
RESTRICT="test"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_MULTI_USEDEP}]
		dev-python/pyxdg[${PYTHON_MULTI_USEDEP}]
	')
	x11-libs/gtk+:3[introspection]
	x11-misc/xdg-utils
"
DEPEND="
	${RDEPEND}
"
DOCS=( CHANGELOG.md CONTRIBUTING.md PLUGIN_WRITING.md README.md )
PATCHES=( "${FILESDIR}"/${PN}-0.60-remove-ubuntu-theme.patch )
S=${WORKDIR}/${PN}-desktop-wiki-${PV/_/-}

python_prepare_all() {
	sed -i -e "s/'USER'/'LOGNAME'/g" zim/__init__.py zim/fs.py || die

	if [[ ${LINGUAS} ]]; then
		local lingua
		for lingua in translations/*.po; do
			lingua=${lingua/.po}
			lingua=${lingua/translations\/}
			has ${lingua} ${LINGUAS} || \
				{ rm translations/${lingua}.po || die; }
		done
	fi

	distutils-r1_python_prepare_all
	export XDG_RUNTIME_DIR=fakethis
}

python_install() {
	distutils-r1_python_install
}

pkg_postinst() {
	xdg_pkg_postinst
	if ! has_version ${CATEGORY}/${PN}; then
		elog "Please install these packages for additional functionality"
		elog "    dev-lang/R"
		elog "    dev-python/gtkspell-python"
		elog "    dev-vcs/bzr"
		elog "    media-gfx/graphviz"
		elog "    media-gfx/imagemagick"
		elog "    media-gfx/scrot"
		elog "    media-sound/lilypond"
		elog "    sci-visualization/gnuplot"
		elog "    virtual/latex-base app-text/dvipng"
	fi
}
