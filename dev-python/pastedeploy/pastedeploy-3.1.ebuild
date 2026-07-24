# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} python3_{14,15}t )

inherit distutils-r1

MY_PN="PasteDeploy"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Load, configure, and compose WSGI applications and servers"
HOMEPAGE="
	https://github.com/Pylons/pastedeploy/
	https://pypi.org/project/PasteDeploy/
"
SRC_URI="
	https://github.com/Pylons/pastedeploy/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

src_prepare() {
	sed -i -e 's:--cov::' pytest.ini || die
	distutils-r1_src_prepare
}
