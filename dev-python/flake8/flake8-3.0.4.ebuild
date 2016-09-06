# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{3,4,5}} )

inherit distutils-r1

DESCRIPTION="A wrapper around PyFlakes, pep8 & mccabe"
HOMEPAGE="https://bitbucket.org/tarek/flake8 https://pypi.python.org/pypi/flake8"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
IUSE="test"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
LICENSE="MIT"
SLOT="0"

# requires.txt inc. mccabe however that creates a circular dep
RDEPEND="
	>=dev-python/pyflakes-0.8.1[${PYTHON_USEDEP}]
	<dev-python/pyflakes-1.3[${PYTHON_USEDEP}]
	!~dev-python/pyflakes-1.2.0
	!~dev-python/pyflakes-1.2.1
	!~dev-python/pyflakes-1.2.2
	>=dev-python/pycodestyle-2.0.0[${PYTHON_USEDEP}]
	<=dev-python/pycodestyle-2.1.0[${PYTHON_USEDEP}]
	"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${PDEPEND}
	    dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pytest-runner[${PYTHON_USEDEP}]
	    $(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7)
	    >=dev-python/mccabe-0.2.1[${PYTHON_USEDEP}]
	        <dev-python/mccabe-0.5[${PYTHON_USEDEP}]
	)"
PDEPEND="
	>=dev-python/mccabe-0.5.0[${PYTHON_USEDEP}]
	<dev-python/mccabe-0.6[${PYTHON_USEDEP}]
	>=dev-python/pycodestyle-2.0.0[${PYTHON_USEDEP}]
	<=dev-python/pycodestyle-2.1.0[${PYTHON_USEDEP}]
	"

python_prepare_all() {
	# Gentoo has flake8 support restored in >=pep8-1.6.2-r1.
	sed -e 's:, != 1.6.2::' -i setup.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	# The test suite assumes the presence of a tox.ini file in ${S},
	# yet the distributed tarballs do not include that file.
	touch "${S}/tox.ini" || die "Could not create tox.ini"

	# using "test" instead of "ptr" results in name collisions
	esetup.py ptr
}
