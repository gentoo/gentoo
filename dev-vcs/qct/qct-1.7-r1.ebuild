# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="PyQt based commit tool for many VCSs"
HOMEPAGE="http://qct.sourceforge.net/"
SRC_URI="http://qct.sourceforge.net/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bazaar cvs mercurial monotone subversion"

DEPEND="app-text/asciidoc[${PYTHON_USEDEP}]
	app-text/xmlto
	dev-python/PyQt4[${PYTHON_USEDEP}]
	bazaar? ( dev-vcs/bzr[${PYTHON_USEDEP}] )
	cvs? ( dev-vcs/cvs )
	mercurial? ( dev-vcs/mercurial[${PYTHON_USEDEP}] )
	monotone? ( dev-vcs/monotone )
	subversion? ( dev-vcs/subversion[${PYTHON_USEDEP}] )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	distutils-r1_src_prepare

	rm qctlib/vcs/p4.py

	# support for git requires cogito which isn't in portage
	rm qctlib/vcs/git.py
	rm qctlib/vcs/cg.py

	use bazaar || rm qctlib/vcs/bzr.py
	use cvs || rm qctlib/vcs/cvs.py
	use mercurial || rm qctlib/vcs/hg.py
	use monotone || rm qctlib/vcs/mtn.py
	use subversion || rm qctlib/vcs/svn.py
}

src_install() {
	distutils-r1_src_install

	# manpage and html docs are built using asciidoc
	make -C doc man html || die
	doman doc/qct.1 || die
	dohtml doc/qct.1.html || die

	if use bazaar; then
		insinto "$(python_get_sitedir)/bzrlib/plugins"
		doins plugins/qctBzrPlugin.py
	fi

	if use mercurial; then
		insinto "$(python_get_sitedir)/hgext"
		doins hgext/qct.py
		insinto /etc/mercurial/hgrc.d
		doins "${FILESDIR}/qct.rc"
	fi
}
