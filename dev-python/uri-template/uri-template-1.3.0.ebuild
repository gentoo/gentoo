# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{12..15} python3_{14,15}t )

inherit distutils-r1 pypi

DESCRIPTION="URI Template expansion in strict adherence to RFC 6570"
HOMEPAGE="
	https://gitlab.linss.com/open-source/python/uri-template/
	https://pypi.org/project/uri-template/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

python_test() {
	"${EPYTHON}" "test.py" || die "Tests fail with ${EPYTHON}"
}
