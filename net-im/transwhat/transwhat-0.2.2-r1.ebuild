# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A WhatsApp XMPP Gateway based on Spectrum 2 and Yowsup 2"
HOMEPAGE="https://github.com/stv0g/transwhat"
SRC_URI="https://github.com/stv0g/transwhat/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-python/e4u[${PYTHON_USEDEP}]
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	net-im/yowsup[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( "INSTALL.rst" "README.rst" "USAGE.rst" )

src_prepare() {
	default

	# Fixes for net-im/spectrum2
	mv config.py Spectrum2/config.py || die
	sed -i -e 's/config import SpectrumConfig/Spectrum2.&/' transWhat/transwhat.py || die
}
