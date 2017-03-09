# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python module for importing and exporting DSV files"
HOMEPAGE="http://python-dsv.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/DSV-${PV}.tar.gz"

LICENSE="CNRI"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/wxpython:3.0[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/DSV-${PV}"

PATCHES=(
	# From Debian
	"${FILESDIR}"/${P}-env.patch
	"${FILESDIR}"/${P}-unicode.patch
	"${FILESDIR}"/${P}-wx-namespace.patch
	"${FILESDIR}"/${P}-wxpython30.patch
)
