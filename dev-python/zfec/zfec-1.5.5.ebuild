# Copyright 1999-2021 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8,9} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="Fast erasure codec for the command-line, C, Python, or Haskell"
HOMEPAGE="https://pypi.org/project/zfec/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-python/pyutil[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/${PN}-1.5.5-no-argparse-setup.patch
)

distutils_enable_tests setup.py

src_install() {
	distutils-r1_src_install

	rm -rf "${ED}"/usr/share/doc/${PN} || die
}
