# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="Multithreaded Click apps made easy."
HOMEPAGE="https://github.com/click-contrib/click-threading https://pypi.python.org/pypi/click-threading"
SRC_URI="https://github.com/click-contrib/${PN}/archive/${PV}.tar.gz -> ${P}-gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-python/click-5.0[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

DOCS=( README.rst )

python_test() {
	py.test -v || die "Tests fail with ${EPYTHON}"
}
