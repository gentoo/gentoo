# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

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

DEPEND="
	app-text/asciidoc
	app-text/xmlto
	dev-python/PyQt4[${PYTHON_USEDEP}]
	bazaar? ( dev-vcs/bzr[${PYTHON_USEDEP}] )
	cvs? ( dev-vcs/cvs )
	mercurial? ( dev-vcs/mercurial[${PYTHON_USEDEP}] )
	monotone? ( dev-vcs/monotone )
	subversion? ( dev-vcs/subversion[${PYTHON_USEDEP}] )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}"

python_prepare_all() {
	# support for git requires cogito which isn't in portage
	rm qctlib/vcs/{p4,git,cg}.py || die

	declare -A delfiles=([bazaar]=bzr [cvs]=cvs [mercurial]=hg [monotone]=mtn [subversion]=svn)
	local i
	for i in "${!delfiles[@]}"; do
		if ! use $i; then
			rm qctlib/vcs/${delfiles[$i]}.py || die
		fi
	done

	distutils-r1_python_prepare_all
}

python_compile_all() {
	# manpage and html docs are built using asciidoc
	emake -C doc man html
	HTML_DOCS=( doc/qct.1.html )
}

python_install_all() {
	doman doc/qct.1

	if use bazaar; then
		python_moduleinto bzrlib/plugins
		python_domodule plugins/qctBzrPlugin.py
	fi

	if use mercurial; then
		python_moduleinto hgext
		python_domodule hgext/qct.py

		insinto /etc/mercurial/hgrc.d
		doins "${FILESDIR}/qct.rc"
	fi

	distutils-r1_python_install_all
}
