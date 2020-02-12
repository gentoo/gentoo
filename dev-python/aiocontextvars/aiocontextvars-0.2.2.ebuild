# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 )
inherit distutils-r1

DESCRIPTION="Asyncio support for PEP-567 contextvars backport"
HOMEPAGE="https://github.com/fantix/aiocontextvars"
SRC_URI="https://github.com/fantix/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

DEPEND="test? ( dev-python/pytest-asyncio[${PYTHON_USEDEP}] )"
RDEPEND="dev-python/contextvars[${PYTHON_USEDEP}]"

distutils_enable_sphinx docs
distutils_enable_tests pytest

python_prepare_all() {
	sed -e 's|'\''pytest-runner'\'',\?||' -i setup.py || die
	distutils-r1_python_prepare_all
}
