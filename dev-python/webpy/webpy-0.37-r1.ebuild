# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/webpy/webpy-0.37-r1.ebuild,v 1.3 2015/01/16 13:03:12 idella4 Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="web.py"

DESCRIPTION="A small and simple web framework for Python"
HOMEPAGE="http://www.webpy.org http://pypi.python.org/pypi/web.py"
SRC_URI="http://www.webpy.org/static/${MY_PN}-${PV}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/web.py-${PV}"

python_test() {
	local return_status="0" test tests="db http net template utils"
	for test in ${tests}; do
		echo "Running doctests in ${test}.py..."
		"${PYTHON}" web/${test}.py || return_status="$?"
	done
		return "${return_status}"
}
