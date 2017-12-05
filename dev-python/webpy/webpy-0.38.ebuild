# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="web.py"

DESCRIPTION="A small and simple web framework for Python"
HOMEPAGE="http://www.webpy.org https://pypi.python.org/pypi/web.py"
SRC_URI="http://www.webpy.org/static/${MY_PN}-${PV}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86 ~amd64-linux ~x86-linux"

S="${WORKDIR}/${MY_PN}-${PV}"

python_test() {
	local t
	for t in db http net template utils; do
		einfo "Running doctests in ${t}.py..."
		"${EPYTHON}" web/${t}.py || die "Test ${t} failed with ${EPYTHON}"
	done
}
