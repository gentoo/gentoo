# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="Generic tagging application for Django"
HOMEPAGE="https://pypi.org/project/django-tagging/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

RDEPEND=">=dev-python/django-1.0[${PYTHON_USEDEP}]"

python_install_all() {
	use doc && dodoc docs/overview.txt
	distutils-r1_python_install_all
}
