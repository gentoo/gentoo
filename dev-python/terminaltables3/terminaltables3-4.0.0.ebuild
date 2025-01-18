# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="Generate simple tables in terminals from a nested list of strings"
HOMEPAGE="
	https://github.com/matthewdeanmartin/terminaltables3/
	https://pypi.org/project/terminaltables3/
"
SRC_URI="
	https://github.com/matthewdeanmartin/terminaltables3/archive/v${PV}.tar.gz
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
	)
"

distutils_enable_tests pytest

python_test() {
	# We override FORCE_COLOR otherwise termcolor
	# would pick it up from env. and give unexpected
	# output for tests.
	FORCE_COLOR=1 epytest
}
