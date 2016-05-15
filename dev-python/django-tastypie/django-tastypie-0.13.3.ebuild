# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1

DESCRIPTION="A flexible and capable API layer for django utilising serialisers"
HOMEPAGE="https://pypi.python.org/pypi/django-tastypie/ https://github.com/toastdriven/django-tastypie"
SRC_URI="https://github.com/toastdriven/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
IUSE="bip doc test"

LICENSE="BSD"
SLOT="0"

COMMON_DEPEND=">=dev-python/mimeparse-0.1.4[${PYTHON_USEDEP}]
		!=dev-python/mimeparse-1.5[${PYTHON_USEDEP}]
		>=dev-python/python-dateutil-1.5[${PYTHON_USEDEP}]
		!=dev-python/python-dateutil-2.0[${PYTHON_USEDEP}]
		>=dev-python/django-1.7[${PYTHON_USEDEP}]
		<dev-python/django-1.10[${PYTHON_USEDEP}]"

RDEPEND="${COMMON_DEPEND}
		bip? ( dev-python/biplist[${PYTHON_USEDEP}] )"

#dev-python/pyyaml is pulled in with django itself
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? (	${COMMON_DEPEND}
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/defusedxml[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '>=dev-python/mock-1.1.0[${PYTHON_USEDEP}]' python2_7)
		>=dev-python/pytz-2013b[${PYTHON_USEDEP}] )
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}]
		>=dev-python/django-1.9[${PYTHON_USEDEP}]
		<dev-python/django-1.10[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '>=dev-python/mock-1.1.0[${PYTHON_USEDEP}]' python2_7)
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}] )"

REQUIRED_USE="test? ( bip )"

python_compile_all() {
	use doc && emake -C docs html
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
