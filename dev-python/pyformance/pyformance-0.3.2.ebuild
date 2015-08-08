# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1

DESCRIPTION="Performance metrics, based on Coda Hale's Yammer metrics"
HOMEPAGE="https://pyformance.readthedocs.org/ https://github.com/omergertel/pyformance/ https://pypi.python.org/pypi/pyformance/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

# https://github.com/omergertel/pyformance/issues/18
# https://github.com/omergertel/pyformance/pull/17
RESTRICT="test"

python_test() {
	PYTHONPATH="${PWD}" python -m unittest \
		$(find tests -name 'test_*.py' | LC_ALL=C sort | sed -e 's:/:.:' -e 's:.py$::') || die
}
