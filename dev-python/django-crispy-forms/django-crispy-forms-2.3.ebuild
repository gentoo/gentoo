# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="DRY Django forms"
HOMEPAGE="
	https://github.com/django-crispy-forms/django-crispy-forms/
	https://pypi.org/project/django-crispy-forms/
"
SRC_URI="
	https://github.com/django-crispy-forms/django-crispy-forms/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/django-4.2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-django[${PYTHON_USEDEP}]
		dev-python/crispy-bootstrap3[${PYTHON_USEDEP}]
		dev-python/crispy-bootstrap4[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
