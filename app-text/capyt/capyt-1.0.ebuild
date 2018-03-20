# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5..6} )

inherit python-single-r1

DESCRIPTION="A python3 CLI utility to interface with cpy.pt paste service"
HOMEPAGE="https://github.com/lbatalha/capyt"
SRC_URI="https://github.com/lbatalha/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	${PYTHON_DEPS}
	dev-python/requests[${PYTHON_USEDEP}]
"

src_install() {
	dodoc README.md

	python_doscript capyt.py
}
