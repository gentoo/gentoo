# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="A python implementation of the jp CLI for JMESPath"
HOMEPAGE="https://github.com/pipebus/jpipe"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"
SLOT="0"
IUSE="jp-symlink test"
RESTRICT="!test? ( test )"
RDEPEND="
	jp-symlink? ( !app-misc/jp )
	dev-python/jmespath[${PYTHON_USEDEP}]
"

python_test() {
	"${PYTHON}" test/test_jpipe.py || die "tests failed for ${EPYTHON}"
}

src_install() {
	distutils-r1_src_install
	use jp-symlink && dosym jpipe /usr/bin/jp
}
