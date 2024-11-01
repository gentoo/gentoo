# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_12 )

inherit distutils-r1 pypi

DESCRIPTION="Bootstrap 5 for Django."
HOMEPAGE="
	https://pypi.org/project/django-bootstrap5/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests pytest

python_test() {
	"${EPYTHON}" -m django test tests --settings tests.app.settings \
		|| die "Tests failed with ${EPYTHON}"
}
