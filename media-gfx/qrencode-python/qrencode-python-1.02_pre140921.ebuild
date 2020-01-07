# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="A simple wrapper for the C qrencode library"
HOMEPAGE="https://pypi.org/project/qrencode/ https://github.com/Arachnid/pyqrencode/"
#SRC_URI="mirror://pypi/q/qrencode/qrencode-${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://github.com/Arachnid/pyqrencode/tarball/486bb7b64e3ce5483f65e375a67da0fa6d02ca92 -> ${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="Apache-2.0"
IUSE=""

RDEPEND="
	dev-python/pillow[${PYTHON_USEDEP}]
	media-gfx/qrencode"
DEPEND="${RDEPEND}"
