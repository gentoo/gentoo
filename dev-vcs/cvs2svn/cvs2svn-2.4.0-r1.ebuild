# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

FILEVER="49237"

DESCRIPTION="Convert a CVS repository to a Subversion repository"
HOMEPAGE="http://cvs2svn.tigris.org/"
SRC_URI="http://cvs2svn.tigris.org/files/documents/1462/${FILEVER}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="bazaar git test"

DEPEND=">=dev-vcs/subversion-1.0.9"
RDEPEND="${DEPEND}
	bazaar? ( >=dev-vcs/bzr-1.13[${PYTHON_USEDEP}] )
	git? ( >=dev-vcs/git-1.5.4.4[${PYTHON_USEDEP}] )
	dev-vcs/rcs"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	distutils-r1_src_prepare
	python_fix_shebang .
}

src_compile() {
	distutils-r1_src_compile
	emake man
}

src_install() {
	distutils-r1_src_install
	insinto "/usr/share/${PN}"
	doins -r contrib cvs2{svn,git,bzr}-example.options
	doman *.1
}

python_test() {
	# Need this because subversion is localized, but the tests aren't
	export LC_ALL=C
	"${PYTHON}" -W ignore run-tests.py
}

pkg_postinst() {
	elog "Additional scripts and examples have been installed to:"
	elog "  /usr/share/${PN}/"
}
