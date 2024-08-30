# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Drop-in replacement for django's many to many field with sorted relations"
HOMEPAGE="
	https://pypi.org/project/django-sortedm2m/
	https://github.com/jazzband/django-sortedm2m/
"
SRC_URI="
	https://github.com/jazzband/django-sortedm2m/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/django[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		$(python_gen_impl_dep sqlite)
		${RDEPEND}
	)
"

python_test() {
	local -x PYTHONPATH=test_project:${PYTHONPATH}
	local -x DB_ENGINE=sqlite3
	local -x DB_NAME=":memory:"
	django-admin test -v 2 --settings=settings --noinput sortedm2m_tests ||
		die "Tests fail with ${EPYTHON}"
}
