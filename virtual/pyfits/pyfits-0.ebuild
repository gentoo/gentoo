# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )

inherit python-r1

DESCRIPTION="Virtual for pyfits"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="|| (
		dev-python/astropy[${PYTHON_USEDEP}]
		>=dev-python/pyfits-3.1[${PYTHON_USEDEP}]
	)"
