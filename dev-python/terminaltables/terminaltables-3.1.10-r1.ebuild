# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Generate simple tables in terminals from a nested list of strings"
HOMEPAGE="
	https://robpol86.github.io/terminaltables/
	https://github.com/matthewdeanmartin/terminaltables/
	https://pypi.org/project/terminaltables/
"
SRC_URI="
	https://github.com/matthewdeanmartin/terminaltables/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

BDEPEND="
	test? (
		dev-python/colorama[${PYTHON_USEDEP}]
		dev-python/colorclass[${PYTHON_USEDEP}]
		dev-python/termcolor[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}"/terminaltables-3.1.0-stdout.patch
)

src_prepare() {
	sed -e '/requires/s:poetry:&-core:' \
		-e '/backend/s:poetry:&.core:' \
		-i pyproject.toml || die

	distutils-r1_src_prepare
}

python_test() {
	# We override FORCE_COLOR otherwise termcolor
	# would pick it up from env. and give unexpected
	# output for tests.
	FORCE_COLOR=1 epytest
}
