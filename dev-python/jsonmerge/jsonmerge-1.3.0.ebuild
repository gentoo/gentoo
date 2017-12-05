# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1

DESCRIPTION="Merge a series of JSON documents"
HOMEPAGE="https://github.com/avian2/jsonmerge/ https://pypi.python.org/pypi/jsonmerge/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# See https://github.com/avian2/jsonmerge/issues/20
REPEND="<=dev-python/jsonschema-2.4.0[${PYTHON_USEDEP}]"
DEPEND="${REPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	PYTHONPATH="${PWD}" python -m unittest \
		$(find tests -name 'test_*.py' | LC_ALL=C sort | sed -e 's:/:.:' -e 's:.py$::') || die
}
