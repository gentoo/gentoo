# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="A simple wrapper for the C qrencode library"
HOMEPAGE="https://pypi.python.org/pypi/qrencode/ https://github.com/Arachnid/pyqrencode/"
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
