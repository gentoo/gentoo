# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 8 -- sys-apps/portage dep
EAPI=8

DISTUTILS_USE_PEP517=no
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="A lil' TOML parser"
HOMEPAGE="
	https://pypi.org/project/tomli/
	https://github.com/hukkin/tomli/
"
SRC_URI="
	https://github.com/hukkin/tomli/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
	$(pypi_wheel_url --unpack)
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"

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
