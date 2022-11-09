# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 7 -- sys-apps/portage dep
EAPI=7

DISTUTILS_USE_PEP517=no
PYTHON_COMPAT=( python3_{8..11} pypy3 )

inherit distutils-r1

DESCRIPTION="A lil' TOML parser"
HOMEPAGE="
	https://pypi.org/project/tomli/
	https://github.com/hukkin/tomli/
"
SRC_URI="
	https://github.com/hukkin/tomli/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
	https://files.pythonhosted.org/packages/py3/${PN::1}/${PN}/${P}-py3-none-any.whl
		-> ${P}-py3-none-any.whl.zip
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~ppc-macos ~x64-macos ~x64-solaris"

BDEPEND="
	app-arch/unzip
"

distutils_enable_tests unittest

python_compile() {
	python_domodule src/tomli "${WORKDIR}"/*.dist-info
}

python_install() {
	distutils-r1_python_install
	python_optimize
}
