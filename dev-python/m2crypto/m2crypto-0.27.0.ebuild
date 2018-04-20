# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

MY_PN="M2Crypto"

DESCRIPTION="M2Crypto: A Python crypto and SSL toolkit"
HOMEPAGE="https://gitlab.com/m2crypto/m2crypto https://pypi.org/project/M2Crypto/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"

IUSE="libressl"

RDEPEND="
	!libressl? ( >=dev-libs/openssl-0.9.8:0=[-bindist(-)] )
	libressl? ( dev-libs/libressl:0= )
	dev-python/typing[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	>=dev-lang/swig-1.3.28:0
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
