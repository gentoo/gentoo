# Copyright 2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{4..7})
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

MY_PN="M2Crypto"

DESCRIPTION="A Python crypto and SSL toolkit"
HOMEPAGE="https://gitlab.com/m2crypto/m2crypto https://pypi.org/project/M2Crypto/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"

# NOTE: Apparently nobody cares about libressl support, dropping support
# IUSE="libressl"

RDEPEND="
	dev-libs/openssl:0=[-bindist(-)]
	virtual/python-typing[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	>=dev-lang/swig-2.0.9
	dev-python/setuptools[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${MY_PN}-${PV}"

# Tests access network, and fail randomly. Bug #431458.
RESTRICT=test

python_compile() {
	# setup.py looks at platform.machine() to determine swig options.
	# For exotic ABIs, we need to give swig a hint.
	# https://bugs.gentoo.org/617946
	# TODO: Fix cross-compiles
	local -x SWIG_FEATURES=
	case ${ABI} in
		x32) SWIG_FEATURES="-D__ILP32__" ;;
	esac
	distutils-r1_python_compile --openssl="${EPREFIX}"/usr
}

python_test() {
	esetup.py test
}
