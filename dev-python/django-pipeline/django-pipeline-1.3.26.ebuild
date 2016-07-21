# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="An asset packaging library for Django"
HOMEPAGE="https://pypi.python.org/pypi/django-pipeline/ https://github.com/cyberdelia/django-pipeline"

# PyPi releases lack docs/ subdir:
# https://github.com/cyberdelia/django-pipeline/pull/254
SRC_URI="https://github.com/cyberdelia/django-pipeline/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc test"

RDEPEND=">=dev-python/django-1.5.8[${PYTHON_USEDEP}]
	dev-python/jsmin[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	virtual/python-futures[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( ${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}] )"

PATCHES=( "${FILESDIR}"/${PV}-tests.patch )

# As usual for test phase
DISTUTILS_IN_SOURCE_BUILD=1

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	# https://github.com/cyberdelia/django-pipeline/issues/381
	PYTHONPATH=. django-admin.py test --settings=tests.settings tests \
		|| die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}

python_install() {
	export PIPELINE_JS_COMPRESSOR = 'pipeline.compressors.jsmin.JSMinCompressor'
	distutils-r1_python_install
}
