# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
PYTHON_REQ_USE="sqlite"
DISTUTILS_USE_PEP517=setuptools
DISTUTILS_SINGLE_IMPL=1
VIRTUALX_REQUIRED=test
inherit distutils-r1 optfeature virtualx xdg

DESCRIPTION="A desktop wiki"
HOMEPAGE="
	https://zim-wiki.org/
	https://github.com/zim-desktop-wiki/zim-desktop-wiki
"
SRC_URI="https://github.com/${PN}-desktop-wiki/${PN}-desktop-wiki/archive/${PV/_/-}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/pygobject:3[${PYTHON_USEDEP}]
		dev-python/pyxdg[${PYTHON_USEDEP}]
	')
	x11-libs/gtk+:3[introspection]
	x11-misc/xdg-utils
"
DEPEND="${RDEPEND}"

DOCS=( CHANGELOG.md CONTRIBUTING.md PLUGIN_WRITING.md README.md )
PATCHES=( "${FILESDIR}"/${PN}-0.60-remove-ubuntu-theme.patch )
S=${WORKDIR}/${PN}-desktop-wiki-${PV/_/-}

python_prepare_all() {
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

python_test() {
	if has_version dev-vcs/git; then
		git config --global user.email "git@example.com" || die
		git config --global user.name "GitExample" || die
	fi

	virtx ./test.py
}

src_install() {
	distutils-r1_src_install

	insinto /usr/share/icons
	doins -r xdg/hicolor
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "Spell checker" app-text/gtkspell[introspection]
	optfeature "GNU R Plot Editor" dev-lang/R
	optfeature "Version control Bazaar support" dev-vcs/bzr
	optfeature "Diagram Editor" media-gfx/graphviz
	optfeature "Insert Screenshot" "media-gfx/imagemagick media-gfx/scrot"
	optfeature "Score Editor" media-sound/lilypond
	optfeature "Gnuplot Editor" sci-visualization/gnuplot
	optfeature "Equation Editor" virtual/latex-base app-text/dvipng
}
