# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4,3_5} pypy )

inherit distutils-r1

DESCRIPTION="Utitilies for maintaining Python packages"
HOMEPAGE="https://github.com/mgorny/gpyutils/"
SRC_URI="https://github.com/mgorny/gpyutils/releases/download/${P}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=app-portage/gentoopm-0.2.9[${PYTHON_USEDEP}]"

python_test() {
	esetup.py test
}
