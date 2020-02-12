# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Downloads and decodes to the weather report for a given station ID"
HOMEPAGE="https://www.schwarzvogel.de/software-pymetar.shtml"
SRC_URI="https://www.schwarzvogel.de/pkgs/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~x86"
IUSE=""

DEPEND=""
RDEPEND=""
