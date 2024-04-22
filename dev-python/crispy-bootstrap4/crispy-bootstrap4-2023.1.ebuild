# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Bootstrap4 template pack for django-crispy-forms"
HOMEPAGE="
	https://github.com/django-crispy-forms/crispy-bootstrap4/
	https://pypi.org/project/crispy-bootstrap4/
"
SRC_URI="
	https://github.com/django-crispy-forms/crispy-bootstrap4/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/django-4.2[${PYTHON_USEDEP}]
	>=dev-python/django-crispy-forms-2.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-django[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
