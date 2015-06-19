# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/PyFoam/PyFoam-0.5.4-r2.ebuild,v 1.3 2015/03/08 23:38:06 pacho Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Tool to analyze and plot the residual files of OpenFOAM computations"
HOMEPAGE="http://openfoamwiki.net/index.php/Contrib_PyFoam"
SRC_URI="http://openfoamwiki.net/images/a/ae/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="extras"

DEPEND="sci-visualization/gnuplot
	|| ( sci-libs/openfoam sci-libs/openfoam-bin )
	extras? (
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/ply[${PYTHON_USEDEP}]
		dev-python/PyQt4[${PYTHON_USEDEP}]
		sci-libs/vtk[${PYTHON_USEDEP}]
	)"

RDEPEND="${DEPEND}"
