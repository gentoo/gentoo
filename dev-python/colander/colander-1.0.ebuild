# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="A simple schema-based serialization and deserialization library"
HOMEPAGE="http://docs.pylonsproject.org/projects/colander/en/latest/ http://pypi.python.org/pypi/colander"
MY_P=${P/_beta1/b1}
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

S="${WORKDIR}/${MY_P}"

# MIT license is used by included (modified) iso8601.py code.
LICENSE="repoze MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc test"

# Depend on an ebuild of translationstring with Python 3 support.
RDEPEND=">=dev-python/translationstring-1.1[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/nose[${PYTHON_USEDEP}]
		dev-python/iso8601[${PYTHON_USEDEP}] )"

# Include COPYRIGHT.txt because the license seems to require it.
DOCS=( CHANGES.rst COPYRIGHT.txt README.rst )

python_prepare_all() {
	# Remove pylons theme since it's not included in source
	sed -e "/# Add and use Pylons theme/,+37d" -i docs/conf.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		# https://github.com/Pylons/colander/issues/38
		emake -C docs html SPHINXOPTS=""
	fi
}

python_test() {
	nosetests || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
