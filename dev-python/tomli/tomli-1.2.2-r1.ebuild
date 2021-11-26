# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 7 -- sys-apps/portage dep
EAPI=7

DISTUTILS_USE_SETUPTOOLS=manual
PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="A lil' TOML parser"
HOMEPAGE="
	https://pypi.org/project/tomli/
	https://github.com/hukkin/tomli/"
SRC_URI="
	https://github.com/hukkin/tomli/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
	https://files.pythonhosted.org/packages/py3/${PN::1}/${PN}/${P}-py3-none-any.whl
		-> ${P}-py3-none-any.whl.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv sparc x86 ~x64-macos"

BDEPEND="
	app-arch/unzip
	test? ( dev-python/python-dateutil[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

# do not use any build system to avoid circular deps
python_compile() { :; }

python_install() {
	python_domodule tomli "${WORKDIR}"/*.dist-info
}
