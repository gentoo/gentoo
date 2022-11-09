# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="Check text files for common misspellings"
HOMEPAGE="https://github.com/codespell-project/codespell"
SRC_URI="https://github.com/codespell-project/codespell/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

# Code licensed under GPL-2
# Dictionary licensed under CC-BY-SA-3.0
LICENSE="GPL-2 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="
	sys-apps/help2man
	test? ( dev-python/chardet[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest

python_prepare_all() {
	distutils-r1_python_prepare_all

	# do not depend on pytest-cov
	sed -e '/addopts/d' -i setup.cfg || die
}

python_compile_all() {
	# generate included man page
	emake ${PN}.1
}

python_install_all() {
	distutils-r1_python_install_all

	doman ${PN}.1
}
