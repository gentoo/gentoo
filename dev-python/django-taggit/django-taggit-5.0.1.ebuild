# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Simple tagging for Django"
HOMEPAGE="
	https://github.com/jazzband/django-taggit/
	https://pypi.org/project/django-taggit/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/django-4.1[${PYTHON_USEDEP}]
	dev-python/djangorestframework[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
	)
"

python_test() {
	"${EPYTHON}" -m django test -v 2 --settings=tests.settings ||
		die "Tests failed with ${EPYTHON}"
}
