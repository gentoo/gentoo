# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Serialize all of Python (almost)"
HOMEPAGE="
	https://github.com/uqfoundation/dill/
	https://pypi.org/project/dill/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

src_prepare() {
	distutils-r1_src_prepare

	# numpy support broken: https://github.com/uqfoundation/dill/issues/667
	sed -i -e 's:import numpy:raise ImportError:' dill/__diff.py || die
}

python_test() {
	# disables a test broken under Python 3.13
	# https://github.com/uqfoundation/dill/issues/668
	local -x COVERAGE=1
	"${EPYTHON}" -m dill.tests || die
}
