# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="QR Code generator on top of PIL"
HOMEPAGE="
	https://github.com/lincolnloop/python-qrcode/
	https://pypi.org/project/qrcode/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~riscv x86"

# optional deps:
# - pillow and lxml for svg backend, set as hard deps
RDEPEND="
	dev-python/lxml[${PYTHON_USEDEP}]
	>=dev-python/pillow-9.1.0[${PYTHON_USEDEP}]
	dev-python/pypng[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# TODO
	qrcode/tests/test_script.py::ScriptTest::test_factory
)

src_install() {
	distutils-r1_src_install
	doman doc/qr.1
}
