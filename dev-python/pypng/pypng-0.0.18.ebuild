# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6})

inherit distutils-r1

DESCRIPTION="Pure Python PNG image encoder/decoder"
HOMEPAGE="https://github.com/drj11/pypng https://pypi.org/project/pypng/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
