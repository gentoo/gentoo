# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Small library containing various image processing algorithms"
HOMEPAGE="https://github.com/jflesch/libpillowfight"
SRC_URI="https://github.com/jflesch/libpillowfight/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/pillow[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_prepare_all() {
	sed -e "/'nose>=1.0'/d" -i setup.py || die
	distutils-r1_python_prepare_all
}
