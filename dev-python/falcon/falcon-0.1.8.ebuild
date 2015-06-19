# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/falcon/falcon-0.1.8.ebuild,v 1.3 2015/04/08 08:05:00 mgorny Exp $

EAPI=5

# Python 2.6 is supported, but depends on ordereddict, which has been in
# improvise for months and is a minimal package. If needed
# please let me know. PyPy also works
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="A supersonic micro-framework for building cloud APIs"
HOMEPAGE="http://falconframework.org/ https://pypi.python.org/pypi/falcon"
SRC_URI="https://github.com/racker/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+cython test"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]
	dev-python/mimeparse[${PYTHON_USEDEP}]
	cython? (
		dev-python/cython[$(python_gen_usedep python{2_7,3_3})] )"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/cython[$(python_gen_usedep python{2_7,3_3})]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/testtools[${PYTHON_USEDEP}] )"

python_test() {
	nosetests || die "Testing failed with ${EPYTHON}"
}

src_prepare() {
	if ! use cython; then
		sed -i -e 's/if with_cython:/if False:/' setup.py \
			|| die 'sed failed.'
	fi

	# fix tests installation : potential file collision
	sed -e 's@^where = tests@where = falcon/tests@g' -i setup.cfg || die
	mv tests falcon/
}
