# Copyright 2020-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P=spur.py-${PV}
DESCRIPTION="Run commands locally or over SSH using the same interface"
HOMEPAGE="
	https://github.com/mwilliamson/spur.py/
	https://pypi.org/project/spur/
"
SRC_URI="
	https://github.com/mwilliamson/spur.py/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 ~riscv x86"

RDEPEND="
	<dev-python/paramiko-4[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

EPYTEST_IGNORE=(
	# TODO: set up a local SSH server?
	tests/ssh_tests.py
)
