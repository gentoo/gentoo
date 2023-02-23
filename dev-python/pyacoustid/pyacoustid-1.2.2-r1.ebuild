# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Python bindings for Chromaprint and the AcoustID web service"
HOMEPAGE="https://pypi.org/project/pyacoustid/"
SRC_URI="
	mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	test? (
		https://s3.wasabisys.com/blocsonic/releases/maxblocs/bsmx0198/01-Follow_192kb.mp3
			-> ${PN}-test.mp3
	)
"

LICENSE="MIT test? ( CC-BY-SA-4.0 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"

# Tests fail with network-sandbox, since they need to connect to acoustid.org
PROPERTIES="test_network"
RESTRICT="test"

RDEPEND="
	dev-python/audioread[${PYTHON_USEDEP},ffmpeg]
	dev-python/requests[${PYTHON_USEDEP}]
	media-libs/chromaprint
"

python_test() {
	# Working test will print the top metadata match from Acoustid's database.
	"${EPYTHON}" aidmatch.py "${DISTDIR}/${PN}-test.mp3" || die "Test failed with ${EPYTHON}"
}

src_install() {
	distutils-r1_src_install

	if use examples ; then
		docinto examples
		dodoc aidmatch.py fpcalc.py
		docompress -x /usr/share/doc/${PF}/examples/
	fi
}
