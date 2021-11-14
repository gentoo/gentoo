# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
inherit distutils-r1

MY_P=python-${P}
DESCRIPTION="Fast JSON schema validator for Python"
HOMEPAGE="https://github.com/horejsek/python-fastjsonschema/"
SRC_URI="
	https://github.com/horejsek/python-fastjsonschema/archive/v${PV}.tar.gz
		-> ${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ia64 ~ppc ppc64 ~riscv ~s390 sparc x86"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare
	rm -r tests/benchmarks || die
}
