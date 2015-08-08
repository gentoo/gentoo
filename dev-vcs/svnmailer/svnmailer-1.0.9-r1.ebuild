# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="A subversion commit notifier written in Python"
HOMEPAGE="http://opensource.perlig.de/svnmailer/"
SRC_URI="http://storage.perlig.de/svnmailer/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${DEPEND}
	dev-vcs/subversion[python,${PYTHON_USEDEP}]
	virtual/mta"
RDEPEND="${DEPEND}"

pkg_setup() {
	python-single-r1_pkg_setup
}

python_prepare_all() {
	sed -i -e "s:man/man1:share/&:" setup.py || die
	distutils-r1_python_prepare_all
}

python_install_all() {
	local HTML_DOCS=( docs/. )
	distutils-r1_python_install_all
}
