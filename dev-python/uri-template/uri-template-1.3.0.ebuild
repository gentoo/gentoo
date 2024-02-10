# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1

MY_P="uri-template-v${PV}"
DESCRIPTION="URI Template expansion in strict adherence to RFC 6570"
HOMEPAGE="
	https://gitlab.linss.com/open-source/python/uri-template/
	https://pypi.org/project/uri-template/
"
SRC_URI="
	https://gitlab.linss.com/open-source/python/uri-template/-/archive/v${PV}/${MY_P}.tar.bz2
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~arm64-macos ~x64-macos"

BDEPEND="
	dev-python/setuptools-scm[${PYTHON_USEDEP}]
"

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}

python_test() {
	"${EPYTHON}" "test.py" || die "Tests fail with ${EPYTHON}"
}
