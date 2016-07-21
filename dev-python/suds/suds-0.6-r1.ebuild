# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 python3_4 python3_5 )
DISTUTILS_IN_SOURCE_BUILD=1

inherit distutils-r1

DESCRIPTION="Lightweight SOAP client (Jurko's fork) (py3 support) (active development)"
HOMEPAGE="https://bitbucket.org/jurko/suds"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}-jurko/${PN}-jurko-${PV}.tar.bz2 -> ${P}.tar.bz2"
S="${WORKDIR}/${PN}-jurko-${PV}"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE="doc test"

REQUIRED_USE="doc? ( $(python_gen_useflags python2_7) )"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/epydoc[$(python_gen_usedep python2_7)] )
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"
RDEPEND=""

DOCS=( README.rst notes/{argument_parsing.rst,readme.txt,traversing_client_data.rst} )

pkg_setup() {
	use doc && DISTUTILS_ALL_SUBPHASE_IMPLS=( python2.7 )
}

python_compile_all() {
	# to say that it's both, because it kinda is...
	! use doc || epydoc -n "Suds - ${DESCRIPTION}" -o doc suds || die
}

python_test() {
	esetup.py test
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/. )
	distutils-r1_python_install_all
}

python_install() {
	# test folder makes for file collisions by the eclass
	sed -i -e '/^tests/d' suds_jurko.egg-info/top_level.txt suds_jurko.egg-info/SOURCES.txt || die
	cp -r suds_jurko.egg-info suds.egg-info || die
	sed -i -e 's/Name\:\ suds-jurko/Name:\ suds/g' -e '/^Obsoletes/d' suds.egg-info/PKG-INFO || die
	rm -rf ./{tests,build/lib/tests,lib/tests}/ || die
	distutils-r1_python_install
}
