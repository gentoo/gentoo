# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{5,6} )

inherit distutils-r1

DESCRIPTION="Python port of Google's libphonenumber"
HOMEPAGE="https://github.com/daviddrysdale/python-phonenumbers"
SRC_URI="https://github.com/daviddrysdale/python-${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

S="${WORKDIR}/python-${PN}-${PV}"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	# the locale test compiles and runs a .java file
	sed -i -r 's/^(alldata:.*)locale/\1/g' tools/python/makefile || die
	emake -C tools/python test
}
