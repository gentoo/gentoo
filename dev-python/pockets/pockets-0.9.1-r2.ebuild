# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

# No tags upstream, https://github.com/RobRuana/pockets/issues/5
COMMIT="777724c8eabaf76f6d0c5e4837c982d110509b2e"

DESCRIPTION="Collection of helpful Python tools"
HOMEPAGE="https://pockets.readthedocs.io/ https://pypi.org/project/pockets/"
SRC_URI="
	https://github.com/RobRuana/pockets/archive/${COMMIT}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
BDEPEND="test? ( dev-python/pytz[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e 's/description-file/description_file/g' "${S}/setup.cfg" ||die
	default
}
