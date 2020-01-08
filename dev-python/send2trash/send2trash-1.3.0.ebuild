# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_{6,7}} )

inherit distutils-r1

MY_PN="Send2Trash"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Sends files to the Trash (or Recycle Bin)"
HOMEPAGE="
	http://hg.hardcoded.net/send2trash
	https://pypi.org/project/Send2Trash/
	https://github.com/hsoft/send2trash"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="amd64 x86"
IUSE="doc"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}"/${MY_P}
