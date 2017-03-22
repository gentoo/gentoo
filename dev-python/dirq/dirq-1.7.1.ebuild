# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python port of Perl module Directory::Queue"
HOMEPAGE="https://github.com/cern-mig/python-dirq"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

# Note: as of 2017-03-22, dirq tests are known to fail in Docker containers
python_test() {
	esetup.py test
}
