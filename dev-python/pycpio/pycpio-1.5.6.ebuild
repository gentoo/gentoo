# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 optfeature shell-completion

DESCRIPTION="Python CPIO library"
HOMEPAGE="https://github.com/desultory/pycpio/"
SRC_URI="
	https://github.com/desultory/pycpio/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64"

RDEPEND="
	>=dev-python/zenlib-3.0.2[${PYTHON_USEDEP}]
"

BDEPEND="test? ( dev-python/zstandard[${PYTHON_USEDEP}] )"

distutils_enable_tests unittest

python_test() {
	eunittest tests
}

python_install_all() {
	distutils-r1_python_install_all
	dozshcomp completion/_pycpio  # Install zsh autocomplete script
}

pkg_postinst() {
	optfeature "zstd compression support" dev-python/zstandard
}
