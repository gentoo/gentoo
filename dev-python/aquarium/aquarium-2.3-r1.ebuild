# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Aquarium web application framework"
HOMEPAGE="http://aquarium.sourceforge.net/ https://pypi.python.org/pypi/aquarium"
SRC_URI="mirror://sourceforge/aquarium/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-python/cheetah[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
