# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/mdanalysis/mdanalysis-0.7.7.ebuild,v 1.2 2015/04/08 18:22:14 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="MDAnalysis"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A python library to analyze and manipulate molecular dynamics trajectories"
HOMEPAGE="https://code.google.com/p/mdanalysis/"
SRC_URI="https://mdanalysis.googlecode.com/files/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	sci-biology/biopython[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	dev-python/scientificpython[${PYTHON_USEDEP}]
	dev-python/GridDataFormats[${PYTHON_USEDEP}]
	dev-python/netcdf4-python[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

S="${WORKDIR}"/${MY_P}
