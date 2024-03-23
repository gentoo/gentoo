# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="readline"

inherit distutils-r1

DESCRIPTION="A library that enables you to build applications which use the WhatsApp service"
HOMEPAGE="https://github.com/tgalal/yowsup"
SRC_URI="https://github.com/tgalal/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

# This package contains no-op tests, so they actually cannot be run
RESTRICT="test"

RDEPEND="
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/ConfigArgParse[${PYTHON_USEDEP}]
	dev-python/consonance[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/protobuf-python[${PYTHON_USEDEP}]
	dev-python/python-axolotl[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${PN}-3.2.3_p20190905-fix-install-path.patch" )

src_prepare() {
	default

	# After talking to upstream, version restriction can be lifted
	# and also 'argparse' needs to be removed.
	sed -e 's/==0.1.5//' -e 's/==0.2.2//' -e 's/==1.10//' -e 's/>=3.6.0//' -e 's/argparse//' -i setup.py || die
}
