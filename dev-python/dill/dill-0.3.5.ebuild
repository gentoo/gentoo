# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Serialize all of Python (almost)"
HOMEPAGE="
	https://github.com/uqfoundation/dill/
	https://pypi.org/project/dill/
"
SRC_URI="
	https://github.com/uqfoundation/dill/archive/${P}.tar.gz
		-> ${P}.gh.tar.gz
"
S=${WORKDIR}/${PN}-${P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

python_test() {
	local fail= t
	for t in tests/test_*.py; do
		ebegin "\t${t}"
		"${EPYTHON}" "${t}"
		eend ${?} || fail=1
	done

	[[ ${fail} ]] && die "Tests fail with ${EPYTHON}"
}
