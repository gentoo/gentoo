# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Bootstrap3 template pack for django-crispy-forms"
HOMEPAGE="
	https://github.com/django-crispy-forms/crispy-bootstrap3/
	https://pypi.org/project/crispy-bootstrap3/
"
SRC_URI="
	https://github.com/django-crispy-forms/crispy-bootstrap3/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/django-crispy-forms[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-django[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
