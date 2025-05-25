# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi optfeature

DESCRIPTION="A full-screen, console-based Python debugger"
HOMEPAGE="
	https://documen.tician.de/pudb/
	https://github.com/inducer/pudb/
	https://pypi.org/project/pudb/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/jedi-0.18[${PYTHON_USEDEP}]
	>=dev-python/packaging-20.0[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.7.4[${PYTHON_USEDEP}]
	>=dev-python/urwid-2.4[${PYTHON_USEDEP}]
	dev-python/urwid-readline[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

pkg_postinst() {
	optfeature_header "Install the following packages for additional functionality:"
	optfeature "Auto-complete support"  dev-python/jedi
}
