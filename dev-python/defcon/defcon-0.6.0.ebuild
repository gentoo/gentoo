# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )
inherit distutils-r1

DESCRIPTION="A set of UFO based objects for use in font editing applications"
HOMEPAGE="https://github.com/typesupply/defcon"
SRC_URI="https://github.com/typesupply/defcon/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

RDEPEND=">=dev-python/fonttools-3.31.0[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND=""

python_test() {
	esetup.py test
}
