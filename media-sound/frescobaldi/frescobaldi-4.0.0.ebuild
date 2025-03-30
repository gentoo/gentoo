# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
inherit desktop distutils-r1 xdg

DESCRIPTION="A LilyPond sheet music text editor"
HOMEPAGE="https://frescobaldi.org/"
SRC_URI="
	https://github.com/frescobaldi/frescobaldi/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/pyqt6-webengine[widgets,${PYTHON_USEDEP}]
		dev-python/pyqt6[gui,network,printsupport,svg,webchannel,widgets,${PYTHON_USEDEP}]
		dev-python/python-ly[${PYTHON_USEDEP}]
		>=dev-python/qpageview-1.0.0[${PYTHON_USEDEP}]
	')
	media-libs/portmidi
	media-sound/lilypond
	x11-themes/tango-icon-theme
"
BDEPEND="
	sys-devel/gettext
"

src_prepare() {
	distutils-r1_src_prepare

	# INSTALL.md suggests that we can do this to use tango-icon-theme
	rm -r frescobaldi/icons/Tango || die

	# formerly these commands used a Makefile, but they've been moved to
	# tox.ini and do not really want to depend on tox just for this
	"${EPYTHON}" i18n/mo-gen.py || die
	msgfmt --desktop -d i18n/frescobaldi \
		--template linux/org.frescobaldi.Frescobaldi.desktop.in \
		-o linux/org.frescobaldi.Frescobaldi.desktop || die
	msgfmt --xml -d i18n/frescobaldi \
		--template linux/org.frescobaldi.Frescobaldi.metainfo.xml.in \
		-o linux/org.frescobaldi.Frescobaldi.metainfo.xml || die
}

src_install() {
	# messy workaround for https://github.com/frescobaldi/frescobaldi/issues/1898
	python_domodule frescobaldi

	distutils-r1_src_install

	dodoc CHANGELOG.md
	doman frescobaldi.1

	domenu linux/org.frescobaldi.Frescobaldi.desktop
	doicon frescobaldi/icons/org.frescobaldi.Frescobaldi.svg

	insinto /usr/share/metainfo
	doins linux/org.frescobaldi.Frescobaldi.metainfo.xml
}
