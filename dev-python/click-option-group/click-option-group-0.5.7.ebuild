# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Click-extension package that adds option groups missing in Click"
HOMEPAGE="
	https://github.com/click-contrib/click-option-group
	https://pypi.org/project/click-option-group/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/click-7.0.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	epytest
}
