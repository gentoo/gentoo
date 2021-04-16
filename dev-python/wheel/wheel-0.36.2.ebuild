# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7,8,9} pypy3 )

inherit distutils-r1

DESCRIPTION="A built-package format for Python"
HOMEPAGE="https://pypi.org/project/wheel/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
SRC_URI="https://github.com/pypa/wheel/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-macos"

distutils_enable_tests pytest

src_prepare() {
	sed \
		-e 's:--cov=wheel::g' \
		-i setup.cfg || die
	distutils-r1_src_prepare
}

python_test() {
	if ! python_is_python3; then
		# install fails due to unicode in paths
		ewarn "Testing is broken with py2.7, please test externally"
		return
	fi

	distutils_install_for_testing --via-root
	pytest -vv || die "Tests failed with ${EPYTHON}"
}
