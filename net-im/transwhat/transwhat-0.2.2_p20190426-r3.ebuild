# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGIT_COMMIT="d022243f6c7b23674d3c87a09819f00b10df1165"
DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="A WhatsApp XMPP Gateway based on Spectrum 2 and Yowsup 3"
HOMEPAGE="https://github.com/stv0g/transwhat"
SRC_URI="https://github.com/stv0g/transwhat/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	dev-python/pyspectrum2[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	net-im/yowsup[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}"

DOCS=( "INSTALL.rst" "README.rst" "USAGE.rst" )

src_prepare() {
	default

	# Spectrum2 must be lower case
	sed \
		-e 's/Spectrum2/spectrum2/g'
		-i transWhat/{buddy,group,registersession,session,transwhat,whatsappbackend}.py || die
}
