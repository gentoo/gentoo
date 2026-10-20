# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="QEMU Monitor Protocol library"
HOMEPAGE="
	https://gitlab.com/qemu-project/python-qemu-qmp
	https://pypi.org/project/qemu.qmp/
"

LICENSE="GPL-2 LGPL-2+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="!<app-emulation/qemu-11.1.2-r0[python]"
BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/urwid-readline[${PYTHON_USEDEP}]
		dev-python/urwid[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

pkg_postinst() {
	optfeature "Terminal User Interface support" "dev-python/pygments dev-python/urwid dev-python/urwid-readline"
}
