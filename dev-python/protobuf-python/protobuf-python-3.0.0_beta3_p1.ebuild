# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
# pypy fails tests; pypy3 fails even running tests
PYTHON_COMPAT=( python2_7 python3_4 python3_5 )

inherit distutils-r1

MY_PV=${PV/_beta/-beta-}
MY_PV=${MY_PV/_p/.}

DESCRIPTION="Google's Protocol Buffers - official Python bindings"
HOMEPAGE="https://github.com/google/protobuf/ https://developers.google.com/protocol-buffers/"
SRC_URI="https://github.com/google/protobuf/archive/v${MY_PV}.tar.gz -> protobuf-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/10b3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-linux ~arm-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

# Protobuf is only a build-time dep, but depend on the exact same version
# (excluding revision), since we are using the same tarball.
# In case of using the (linked) cpp implementation we should be fine with the same subslot.
RDEPEND="${PYTHON_DEPS}
	!<dev-libs/protobuf-3[python(-)]"
DEPEND="${RDEPEND}
	>=dev-libs/protobuf-3
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
S="${WORKDIR}/protobuf-${MY_PV}/python"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
PATCHES=( "${FILESDIR}/${PN}-3.0.0_beta3-link-against-installed-lib.patch" )

python_test() {
	distutils_install_for_testing
	esetup.py test
}
