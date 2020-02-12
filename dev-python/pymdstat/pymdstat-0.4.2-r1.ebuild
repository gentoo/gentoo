# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,8} pypy3 )
inherit distutils-r1

DESCRIPTION="Python library to parse Linux /proc/mdstat"
HOMEPAGE="https://github.com/nicolargo/pymdstat
	https://pypi.org/project/pymdstat/"

# drop the ${PVR} if there is a version bump
SRC_URI="https://github.com/nicolargo/${PN}/archive/v${PV}.tar.gz -> ${PN}-${PVR}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

DOCS=( 'AUTHORS' 'NEWS' 'README.rst' )

python_prepare_all() {
	sed -e '/data_files/ d' -i setup.py || die "sed failed"
	distutils-r1_python_prepare_all
}

python_test() {
	"${EPYTHON}" unitest.py -v || die "testing failed with ${EPYTHON}"
}
