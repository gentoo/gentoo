# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Python interface to XPA to communicate with DS9"
HOMEPAGE="https://github.com/ericmandel/pyds9"
SRC_URI="https://github.com/ericmandel/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="x11-libs/xpa:0
	dev-python/six[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

DOCS=(changelog README.md)

PATCHES=( "${FILESDIR}/${P}-use-system-xpa.patch" )
