# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_4 pypy )

inherit distutils-r1

DESCRIPTION="API abstracting the BioMagResBank (BMRB) NMR-STAR format (http://www.bmrb.wisc.edu/)"
HOMEPAGE="http://gna.org/projects/bmrblib/"
SRC_URI="http://download.gna.org/${PN}/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""
