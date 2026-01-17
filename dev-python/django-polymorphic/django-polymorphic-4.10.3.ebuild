# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{12..14} )

inherit distutils-r1

DESCRIPTION="Seamless Polymorphic Inheritance for Django Models"
HOMEPAGE="
	https://github.com/jazzband/django-polymorphic/
	https://pypi.org/project/django-polymorphic/
"
SRC_URI="
	https://github.com/jazzband/django-polymorphic/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/django-4.2[$PYTHON_USEDEP]
"
BDEPEND="
	test? (
		$(python_gen_impl_dep sqlite)
		${RDEPEND}
		dev-python/dj-database-url[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-{django,mock} )
distutils_enable_tests pytest

python_test() {
	local EPYTEST_IGNORE=(
		# requires playwright
		src/polymorphic/tests/test_admin.py
		# some of them require playwright, others break subsequent tests
		src/polymorphic/tests/examples
		# require django-test-migrations
		src/polymorphic/tests/test_migrations
		src/polymorphic/tests/test_serialization.py
	)

	rm -f conftest.py || die
	epytest -o addopts=
}
