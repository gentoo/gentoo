# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Django App that adds CORS (Cross-Origin Resource Sharing) headers to responses"
HOMEPAGE="
	https://github.com/adamchainz/django-cors-headers/
	https://pypi.org/project/django-cors-headers/
"
SRC_URI="
	https://github.com/adamchainz/django-cors-headers/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/asgiref-3.6[${PYTHON_USEDEP}]
	>=dev-python/django-4.2[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( pytest-django )
distutils_enable_tests pytest
