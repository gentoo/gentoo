# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="hgsubversion is a Mercurial extension for working with Subversion repositories"
HOMEPAGE="https://bitbucket.org/durin42/hgsubversion/wiki/Home http://pypi.python.org/pypi/hgsubversion"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="test"

# although any ref absent in the source, tests fail badly with >=mercurial-2.8.1
RDEPEND=">=dev-vcs/mercurial-1.4[${PYTHON_USEDEP}]
	dev-vcs/mercurial[${PYTHON_USEDEP}]
	|| (
		>=dev-python/subvertpy-0.7.4[${PYTHON_USEDEP}]
		>=dev-vcs/subversion-1.5[python] )"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

DOCS=( README )

#python_test() {
#	"${PYTHON}" tests/run.py || die "Tests failed under ${EPYTHON}"
#}
