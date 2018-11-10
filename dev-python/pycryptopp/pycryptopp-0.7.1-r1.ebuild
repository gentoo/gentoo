# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 vcs-snapshot

NUM="869544967005693312591928092448767568728501330214"
MY_P="${P}.${NUM}"

DESCRIPTION="Python wrappers for a few algorithms from the Crypto++ library"
HOMEPAGE="https://tahoe-lafs.org/trac/pycryptopp
	https://pypi.org/project/pycryptopp/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/crypto++"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS="NEWS.rst"

PATCHES=( "${FILESDIR}"/${PN}-0.7.1-abi-change.patch )

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	# Don't install license files
	sed -i -e "/data_files=data_files,/d" setup.py || die

	distutils-r1_python_prepare_all
}

python_compile() {
	# use system crypto++ library
	distutils-r1_python_compile --disable-embedded-cryptopp
}

python_test() {
	esetup.py test
}
