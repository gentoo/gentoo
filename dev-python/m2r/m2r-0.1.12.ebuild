# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy)

inherit distutils-r1

DESCRIPTION="Markdown to reStructuredText converter"
HOMEPAGE="https://github.com/miyakogi/m2r https://pypi.python.org/pypi/m2r"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
IUSE="test"

RDEPEND="
	dev-python/mistune[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( $(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7) )
	${RDEPEND}
"

#S=${WORKDIR}/${P}

python_prepare_all() {
	# fix a Q/A violation, trying to install the tests as an independant package
	sed -e "s/packages=\['tests'\],/packages=[],/" -i setup.py
	# add missing test files
	cp "${FILESDIR}/"test.md tests/ || die
	cp "${FILESDIR}/"test.rst tests/ || die
	cp "${FILESDIR}/"m2r.1 ./ || die
	distutils-r1_python_prepare_all
}

python_test() {
	py.test -v || die "Tests failed with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all
	doman m2r.1
}
