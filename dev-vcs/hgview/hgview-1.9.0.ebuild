# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )
DISTUTILS_IN_SOURCE_BUILD=1
inherit distutils-r1

DESCRIPTION="A Mercurial interactive history viewer"
HOMEPAGE="http://www.logilab.org/project/hgview/ https://pypi.python.org/pypi/hgview/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc ncurses +qt4"
REQUIRED_USE="|| ( ncurses qt4 )"

RDEPEND="dev-vcs/mercurial[${PYTHON_USEDEP}]
	ncurses? (
		>=dev-python/urwid-1.0.0[${PYTHON_USEDEP}]
		dev-python/pyinotify[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
	)
	qt4? (
		dev-python/docutils[${PYTHON_USEDEP}]
		dev-python/PyQt4[X,${PYTHON_USEDEP}]
		dev-python/qscintilla-python[${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}
	doc? (
		app-text/asciidoc
		app-text/xmlto
	)"

python_configure_all() {
	mydistutilsargs=(
		build $(use doc || echo --no-doc)
		build $(use ncurses || echo --no-curses)
		build $(use qt4 || echo --no-qt)
	)
}

src_prepare() {
	# https://www.logilab.org/ticket/103668
	sed -i \
		-e 's:MANDIR=$(PREFIX)/man:MANDIR=$(PREFIX)/share/man:' \
		-e 's:$(INSTALL) $$i:$(INSTALL) -m 644 $$i:' \
		doc/Makefile || die

	distutils-r1_src_prepare
}

src_install() {
	distutils-r1_src_install

	# Install Mercurial extension config file
	insinto /etc/mercurial/hgrc.d
	doins hgext/hgview.rc
}
