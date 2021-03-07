# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit distutils-r1

DESCRIPTION="Simplified object-oriented Python extension module for libpcap"
HOMEPAGE="https://github.com/pynetwork/pypcap https://pypi.org/project/pypcap/"
SRC_URI="https://github.com/pynetwork/pypcap/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"
RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.2.3-mktemp.patch
)

python_compile() {
	local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"

	# Needed to gain Python 3.9 compatibility
	cython pcap.pyx || die "Failed to regenerate pcap.pyx"

	# Now build as usual
	distutils-r1_python_compile
}

python_test() {
	cd tests || die
	"${EPYTHON}" test.py || die
}
