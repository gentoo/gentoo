# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1

DESCRIPTION="A Django app providing database and form fields for pytz timezone objects"
HOMEPAGE="https://github.com/mfogel/django-timezone-field"
SRC_URI="
	https://github.com/mfogel/django-timezone-field/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/django-2.2[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '
		dev-python/backports-zoneinfo[${PYTHON_USEDEP}]
	' 3.8)
"
BDEPEND="
	test? (
		dev-python/djangorestframework[${PYTHON_USEDEP}]
		dev-python/pytest-django[${PYTHON_USEDEP}]
		dev-python/pytest-lazy-fixture[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_test() {
	local -x DB_ENGINE=sqlite
	epytest
}
