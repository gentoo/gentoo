# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="An extension to django CMS to provide multilingual Haystack indexes"
HOMEPAGE="https://pypi.python.org/pypi/aldryn-search"
SRC_URI="https://github.com/aldryn/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/lxml[${PYTHON_USEDEP}]
	>=dev-python/django-1.4[${PYTHON_USEDEP}]
	dev-python/django-appconf[${PYTHON_USEDEP}]
	>=dev-python/django-cms-3.0[${PYTHON_USEDEP}]
	>=dev-python/django-haystack-2.0.0[${PYTHON_USEDEP}]
	dev-python/django-spurl[${PYTHON_USEDEP}]
	dev-python/django-standard-form[${PYTHON_USEDEP}]
	>=dev-python/aldryn-common-1.0.2[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
