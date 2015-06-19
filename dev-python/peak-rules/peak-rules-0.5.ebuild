# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/peak-rules/peak-rules-0.5.ebuild,v 1.4 2015/04/08 08:04:57 mgorny Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

MY_PN="PEAK-Rules"
MY_P="${MY_PN}-${PV}a1.dev-r2713"

DESCRIPTION="Generic functions and business rules support systems"
HOMEPAGE="http://peak.telecommunity.com/ https://pypi.python.org/pypi/PEAK-Rules/"
SRC_URI="http://peak.telecommunity.com/snapshots/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="ZPL"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DOCS=( Code-Generation.txt Criteria.txt Indexing.txt README.txt Syntax-Matching.txt  )

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/bytecodeassembler-0.6[${PYTHON_USEDEP}]
	>=dev-python/addons-0.6[${PYTHON_USEDEP}]
	>=dev-python/extremes-1.1[${PYTHON_USEDEP}]
	test? ( >=dev-python/importing-1.10[${PYTHON_USEDEP}] )"

S="${WORKDIR}"/${MY_P}

python_test() {
	PYTHONPATH=$PYTHONPATH:"${S}"/peak/rules/ "${PYTHON}" test_rules.py \
		&& einfo "Tests passed under ${EPYTHON}" \
		|| die "Tests failed under ${EPYTHON}"
}

src_test() {
	# Relative import misfires for core.py during emerge
	sed -e "s:from peak.rules.core:from core:" -i test_rules.py
	distutils-r1_src_test
	# Return to original statefor final install
	sed -e "s:from core:from peak.rules.core:" -i test_rules.py
}
