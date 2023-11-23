# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1

DESCRIPTION="Table/data-grid framework for Django"
HOMEPAGE="
	https://pypi.org/project/django-tables2/
	https://github.com/jieter/django-tables2/
"
SRC_URI="
	https://github.com/jieter/django-tables2/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

SLOT="0"
LICENSE="BSD-2"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/django-3.2[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		dev-python/django-filter[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/psycopg:2[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	)
"

src_prepare() {
	# these tests require tablib
	rm tests/test_export.py tests/test_templatetags.py || die
	# these tests require fudge
	rm tests/test_config.py || die

	distutils-r1_src_prepare
}

python_test() {
	"${EPYTHON}" manage.py test -v 2 tests || die
}
