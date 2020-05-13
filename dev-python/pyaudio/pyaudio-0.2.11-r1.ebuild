# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1

MY_PN="PyAudio"

DESCRIPTION="Python bindings for PortAudio"
HOMEPAGE="http://people.csail.mit.edu/hubert/pyaudio/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND="media-libs/portaudio"
DEPEND="${RDEPEND}
	test? ( dev-python/numpy )"

distutils_enable_sphinx sphinx
distutils_enable_tests unittest

python_test() {
	cd tests || die
	# pyaudio_tests have very complicated runtime requirements, therefore skipping them.
	"${EPYTHON}" -m unittest error_tests -v ||
		die "Tests fail with ${EPYTHON}"
}
