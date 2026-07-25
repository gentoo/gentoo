# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="SSH2 protocol library"
HOMEPAGE="
	https://www.paramiko.org/
	https://github.com/paramiko/paramiko/
	https://pypi.org/project/paramiko/
"
SRC_URI="
	https://github.com/paramiko/paramiko/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

RDEPEND="
	>=dev-python/bcrypt-3.2[${PYTHON_USEDEP}]
	>=dev-python/cryptography-3.3[${PYTHON_USEDEP}]
	>=dev-python/pynacl-1.5[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
EPYTEST_RERUNS=5
distutils_enable_tests pytest

src_prepare() {
	local PATCHES=(
		"${FILESDIR}/${PN}-5.0.0-nih-test-deps.patch"
	)

	distutils-r1_src_prepare

	# optional dep
	sed -i -e '/invoke/d' pyproject.toml || die
}
