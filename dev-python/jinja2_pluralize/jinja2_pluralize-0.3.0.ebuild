# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{6,7}} )

inherit distutils-r1

DESCRIPTION="Jinja2 pluralize filters"
HOMEPAGE="https://github.com/audreyr/jinja2_pluralize"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/inflect[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]"

python_test() {
	esetup.py test || die "tests failed with ${EPYTHON}"
}
