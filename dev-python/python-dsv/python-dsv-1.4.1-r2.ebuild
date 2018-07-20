# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python module for importing and exporting DSV files"
HOMEPAGE="http://python-dsv.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/DSV-${PV}.tar.gz
	https://dev.gentoo.org/~mgorny/dist/${P}-gentoo-patchset.tar.bz2"

LICENSE="CNRI"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/wxpython:3.0[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

S="${WORKDIR}/DSV-${PV}"

PATCHES=(
	# From Debian
	"${WORKDIR}/${P}-gentoo-patchset"/${P}-env.patch
	"${WORKDIR}/${P}-gentoo-patchset"/${P}-unicode.patch
	"${WORKDIR}/${P}-gentoo-patchset"/${P}-wx-namespace.patch
	"${WORKDIR}/${P}-gentoo-patchset"/${P}-wxpython30.patch
)
