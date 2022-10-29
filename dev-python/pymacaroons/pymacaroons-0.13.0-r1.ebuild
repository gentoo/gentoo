# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="A Python implementation of Macaroons"
HOMEPAGE="
	https://github.com/ecordell/pymacaroons
	https://pypi.org/project/pymacaroons/
"
SRC_URI="
	https://github.com/ecordell/pymacaroons/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
	https://github.com/arkamar/pymacaroons/commit/backport-upstream-pr59.patch
		-> ${P}-nose-to-pytest.patch
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64"

RDEPEND="
	dev-python/pynacl[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

PATCHES=(
	# The patch is backported from upstream PR #59 to v0.13.0 and stored in my
	# fork, see SRC_URI.
	"${DISTDIR}/${P}-nose-to-pytest.patch"
)

EPYTEST_IGNORE=(
	# The package also contains property_tests, however, they are incompatible
	# with dev-python/hypothesis in gentoo. The package requires too old version.
	tests/property_tests
)

distutils_enable_tests pytest
