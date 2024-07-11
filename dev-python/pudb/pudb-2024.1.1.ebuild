# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

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
	>=dev-python/urwid-2.4[${PYTHON_USEDEP}]
	dev-python/urwid-readline[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
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
