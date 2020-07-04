# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Python bindings for Chromaprint and the AcoustID web service"
HOMEPAGE="https://pypi.org/project/pyacoustid/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	dev-python/audioread[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	media-libs/chromaprint
"

src_install() {
	distutils-r1_src_install

	if use examples ; then
		docinto examples
		dodoc aidmatch.py fpcalc.py
		docompress -x /usr/share/doc/${PF}/examples/
	fi
}
