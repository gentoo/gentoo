# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Compile SASS files to Qt stylesheets"
HOMEPAGE="https://github.com/spyder-ide/qtsass"
SRC_URI="https://github.com/spyder-ide/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/libsass[${PYTHON_USEDEP}]"

distutils_enable_tests pytest

python_prepare_all() {
	# assert 1 == 2
	sed -i -e 's:test_watchers:_&:' tests/test_watchers.py || die

	distutils-r1_python_prepare_all
}
