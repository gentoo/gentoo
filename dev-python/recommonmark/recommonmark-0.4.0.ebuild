# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="Python docutils-compatibility bridge to CommonMark"
HOMEPAGE="https://recommonmark.readthedocs.io/"
LICENSE="MIT"

SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
RDEPEND="
	dev-python/docutils[${PYTHON_USEDEP}]
	<=dev-python/CommonMark-0.5.4[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

IUSE=""
