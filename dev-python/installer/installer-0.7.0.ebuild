# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# please keep this ebuild at EAPI 8 -- sys-apps/portage dep
EAPI=8

DISTUTILS_USE_PEP517=no
PYTHON_COMPAT=( python3_{11..14} python3_{13,14}t pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="A library for installing Python wheels"
HOMEPAGE="
	https://pypi.org/project/installer/
	https://github.com/pypa/installer/
	https://installer.readthedocs.io/en/latest/
"
SRC_URI+="
	$(pypi_wheel_url --unpack)
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

BDEPEND="
	app-arch/unzip
"

distutils_enable_tests pytest

python_compile() {
	python_domodule src/installer "${WORKDIR}"/*.dist-info
}

python_install() {
	distutils-r1_python_install
	python_optimize
}
