# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy )

inherit distutils-r1

DESCRIPTION="Python package for parsing and generating vCard and vCalendar files"
HOMEPAGE="http://eventable.github.io/vobject/
	https://pypi.python.org/pypi/vobject
	https://github.com/eventable/vobject"
SRC_URI="https://github.com/eventable/vobject/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-python/python-dateutil-2.4.0[${PYTHON_USEDEP}]
	dev-python/setuptools"[${PYTHON_USEDEP}]
DEPEND="${RDEPEND}"

DOCS=( ACKNOWLEDGEMENTS.txt README.md )

python_test() {
	"${EPYTHON}" tests.py || die "Testing failed under ${EPYTHON}"
}
