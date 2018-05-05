# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{3_4,3_5} )
PYTHON_REQ_USE="ncurses(+)"

inherit distutils-r1

MY_PV=${PV/_/-}

DESCRIPTION="A software for Gentoo installation"
HOMEPAGE="https://github.com/ChrisADR/installer"
SRC_URI="mirror://github.com/ChrisADR/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64"

S="${WORKDIR}/${PN}-${MY_PV}"
DOCS=( README.md CONTRIBUTING.md )
