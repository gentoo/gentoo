# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python3_{6,7} )
DISTUTILS_IN_SOURCE_BUILD=1

inherit distutils-r1

DESCRIPTION="Lightweight SOAP client (Jurko's fork) (py3 support) (active development)"
HOMEPAGE="https://bitbucket.org/jurko/suds"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}-jurko/${PN}-jurko-${PV}.tar.bz2 -> ${P}.tar.bz2"
S="${WORKDIR}/${PN}-jurko-${PV}"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"
RDEPEND=""

DOCS=( README.rst notes/{argument_parsing.rst,readme.txt,traversing_client_data.rst} )

python_test() {
	esetup.py test
}

python_install() {
	# test folder makes for file collisions by the eclass
	sed -i -e '/^tests/d' suds_jurko.egg-info/top_level.txt suds_jurko.egg-info/SOURCES.txt || die
	cp -r suds_jurko.egg-info suds.egg-info || die
	sed -i -e 's/Name\:\ suds-jurko/Name:\ suds/g' -e '/^Obsoletes/d' suds.egg-info/PKG-INFO || die
	rm -rf ./{tests,build/lib/tests,lib/tests}/ || die
	distutils-r1_python_install
}
