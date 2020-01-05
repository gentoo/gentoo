# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="PyQt4/PyQt5 compatibility layer"
HOMEPAGE="https://github.com/ales-erjavec/anyqt"
SRC_URI="https://github.com/ales-erjavec/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${RDEPEND}"
