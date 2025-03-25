# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..13} )

inherit distutils-r1 pypi

DESCRIPTION="Bootstrap 5 for Django."
HOMEPAGE="
	https://pypi.org/project/django-bootstrap5/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/django[${PYTHON_USEDEP}]
	dev-python/jinja2[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="test? ( sci-libs/gdal )"

distutils_enable_tests pytest

src_prepare() {
	rm tests/test_urls.py || die
	distutils-r1_src_prepare
}

python_test() {
	"${EPYTHON}" -m django test tests --settings tests.app.settings \
		|| die "Tests failed with ${EPYTHON}"
}
