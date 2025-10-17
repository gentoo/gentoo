# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1

DESCRIPTION="Simple tagging for Django"
HOMEPAGE="
	https://github.com/jazzband/django-taggit/
	https://pypi.org/project/django-taggit/
"
SRC_URI="
	https://github.com/jazzband/django-taggit/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-python/django-4.1[${PYTHON_USEDEP}]
	dev-python/djangorestframework[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=( pytest-django )
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=()

	if has_version "dev-python/unidecode[${PYTHON_USEDEP}]"; then
		EPYTEST_DESELECT+=(
			# https://github.com/jazzband/django-taggit/issues/856
			tests/test_models.py::TestSlugification::test_old_slugs
		)
	fi

	epytest -o DJANGO_SETTINGS_MODULE=tests.settings
}
