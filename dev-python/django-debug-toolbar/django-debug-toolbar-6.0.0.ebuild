# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="A configurable set of panels that display various debug information"
HOMEPAGE="
	https://github.com/django-commons/django-debug-toolbar/
	https://pypi.org/project/django-debug-toolbar/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-python/django-4.2.9[${PYTHON_USEDEP}]
	elibc_musl? ( dev-python/tzdata )
"

BDEPEND="
	test? (
		dev-python/django-template-partials[${PYTHON_USEDEP}]
		dev-python/html5lib[${PYTHON_USEDEP}]
	)
"

src_prepare() {
	distutils-r1_src_prepare

	# requires django-csp
	rm tests/test_csp_rendering.py || die
}

python_test() {
	"${EPYTHON}" -m django test -v 2 --settings tests.settings tests \
		|| die "Tests failed with ${EPYTHON}"
}
