# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )
inherit desktop distutils-r1 xdg

DESCRIPTION="A LilyPond sheet music text editor"
HOMEPAGE="https://frescobaldi.org/"
SRC_URI="https://github.com/frescobaldi/frescobaldi/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/pyqt6-webengine[widgets,${PYTHON_USEDEP}]
		dev-python/pyqt6[gui,network,printsupport,svg,webchannel,widgets,${PYTHON_USEDEP}]
		dev-python/python-ly[${PYTHON_USEDEP}]
		>=dev-python/qpageview-1.0.1[${PYTHON_USEDEP}]
	')
	media-libs/portmidi
	media-sound/lilypond
	x11-themes/tango-icon-theme
"

src_prepare() {
	distutils-r1_src_prepare

	# INSTALL.md suggests that we can do this to use tango-icon-theme
	rm -r frescobaldi/icons/Tango || die
}

src_install() {
	distutils-r1_src_install

	dodoc CHANGELOG.md
	doman frescobaldi.1

	domenu linux/org.frescobaldi.Frescobaldi.desktop
	doicon frescobaldi/icons/org.frescobaldi.Frescobaldi.svg

	insinto /usr/share/metainfo
	doins linux/org.frescobaldi.Frescobaldi.metainfo.xml
}
