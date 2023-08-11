# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1 pypi

DESCRIPTION="A configurable set of panels that display various debug information"
HOMEPAGE="
	https://github.com/jazzband/django-debug-toolbar/
	https://pypi.org/project/django-debug-toolbar/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/django[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/html5lib[${PYTHON_USEDEP}]
	)
"

python_test() {
	"${EPYTHON}" -m django test -v 2 --settings tests.settings \
		|| die "Tests failed with ${EPYTHON}"
}
