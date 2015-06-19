# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/markups/markups-0.6.1.ebuild,v 1.1 2015/05/27 07:58:08 jlec Exp $

EAPI="5"

PYTHON_COMPAT=( python2_7 python3_{3,4} pypy )

inherit distutils-r1

MY_PN="Markups"
MY_P=${MY_PN}-${PV}

DESCRIPTION="A wrapper around various text markups"
HOMEPAGE="http://pypi.python.org/pypi/Markups"
SRC_URI="mirror://pypi/M/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"/${MY_P}

DEPEND="dev-python/markdown[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_test() {
	pushd tests > /dev/null
		for test in test_*.py ; do
			local testName="$(echo ${test} | sed 's/test_\(.*\).py/\1/g')"
			if [[ ${testName} == "web" ]]; then
				$(python_is_python3) || continue
			fi
			einfo "Running test '${testName}' with '${EPYTHON}'."
			${EPYTHON} ${test} || die "Test '${testName}' with '${EPYTHON}' failed."
		done
	popd tests > /dev/null
}
