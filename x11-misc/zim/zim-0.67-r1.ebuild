# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="sqlite"
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 gnome2-utils virtualx xdg-utils

DESCRIPTION="A desktop wiki"
HOMEPAGE="http://zim-wiki.org/"
SRC_URI="http://zim-wiki.org/downloads/${P}.tar.gz"

LICENSE="BSD GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/pygtk[${PYTHON_USEDEP}]
	dev-python/pygobject:2[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	x11-misc/xdg-utils
	test? (
		dev-vcs/bzr
		dev-vcs/git
		dev-vcs/mercurial )"

DOCS=( CHANGELOG.txt README.txt HACKING )
PATCHES=( "${FILESDIR}"/${PN}-0.60-remove-ubuntu-theme.patch )

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
	VIRTUALX_COMMAND="${PYTHON}" virtualmake test.py
}

python_install() {
	distutils-r1_python_install --skip-xdg-cmd
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
	gnome2_icon_cache_update
	if ! has_version ${CATEGORY}/${PN}; then
		einfo "Please emerge these packages for additional functionality"
		einfo "    dev-lang/R"
		einfo "    dev-python/gtkspell-python"
		einfo "    dev-vcs/bzr"
		einfo "    media-gfx/graphviz"
		einfo "    media-gfx/imagemagick"
		einfo "    media-gfx/scrot"
		einfo "    media-sound/lilypond"
		einfo "    sci-visualization/gnuplot"
		einfo "    virtual/latex-base app-text/dvipng"
	fi
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
	gnome2_icon_cache_update
}
