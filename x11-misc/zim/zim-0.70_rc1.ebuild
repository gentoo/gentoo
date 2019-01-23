# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{4,5,6} )
PYTHON_REQ_USE="sqlite"
DISTUTILS_SINGLE_IMPL=1
inherit xdg-utils distutils-r1 gnome2-utils virtualx

DESCRIPTION="A desktop wiki"
HOMEPAGE="
	http://zim-wiki.org/
	https://github.com/zim-desktop-wiki/
"
SRC_URI="https://github.com/${PN}-desktop-wiki/${PN}-desktop-wiki/archive/${PV/_/-}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	x11-libs/gtk+:3[introspection]
	x11-misc/xdg-utils
"
DEPEND="
	${RDEPEND}
	test? (
		dev-vcs/bzr
		dev-vcs/git
		dev-vcs/mercurial
	)
"
DOCS=( CHANGELOG.txt README.txt HACKING )
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
}

python_test() {
	virtx ${PYTHON} test.py
}

python_install() {
	distutils-r1_python_install
}

pkg_postinst() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
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

pkg_postrm() {
	gnome2_icon_cache_update
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
