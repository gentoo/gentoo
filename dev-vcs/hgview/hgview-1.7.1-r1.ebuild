# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_IN_SOURCE_BUILD=1
inherit distutils-r1

DESCRIPTION="PyQt4-based Mercurial log navigator"
HOMEPAGE="http://www.logilab.org/project/hgview"
SRC_URI="http://ftp.logilab.org/pub/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/PyQt4[${PYTHON_USEDEP},X]
	dev-python/qscintilla-python[${PYTHON_USEDEP}]
	dev-vcs/mercurial[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	doc? (
		app-text/asciidoc
		app-text/xmlto
	)"

python_configure_all() {
	mydistutilsargs=(
		build $(use doc || echo --no-doc)
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
