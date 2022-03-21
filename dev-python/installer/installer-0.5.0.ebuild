# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 7 -- sys-apps/portage dep
EAPI=7

DISTUTILS_USE_SETUPTOOLS=manual
PYTHON_COMPAT=( python3_{8..10} pypy3 )
inherit distutils-r1

DESCRIPTION="A library for installing Python wheels"
HOMEPAGE="
	https://pypi.org/project/installer/
	https://github.com/pradyunsg/installer/
	https://installer.readthedocs.io/en/latest/
"
SRC_URI="
	https://github.com/pradyunsg/installer/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
	https://files.pythonhosted.org/packages/py3/${PN::1}/${PN}/${P%_p*}-py3-none-any.whl
		-> ${P%_p*}-py3-none-any.whl.zip
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

BDEPEND="
	app-arch/unzip
"

distutils_enable_tests pytest

# do not use any build system to avoid circular deps
python_compile() { :; }

python_test() {
	local -x PYTHONPATH=src
	epytest
}

python_install() {
	python_domodule src/installer "${WORKDIR}"/*.dist-info
}
