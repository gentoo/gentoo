# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Serialize all of python (almost)"
HOMEPAGE="https://pypi.org/project/dill/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~x86 ~amd64-linux ~x86-linux"

python_test() {
	local fail= t
	for t in tests/test_*.py; do
		ebegin "\t${t}"
		"${EPYTHON}" "${t}"
		eend || fail=1
	done

	[[ ${fail} ]] && die "Tests fail with ${EPYTHON}"
}
