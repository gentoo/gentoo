# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7,8,9,10} )

inherit distutils-r1

DESCRIPTION="A python implementation of the jp CLI for JMESPath"
HOMEPAGE="https://github.com/pipebus/jpipe https://github.com/jmespath/jmespath.py/pull/224"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64"
SLOT="0"
IUSE="jpp-symlink jp-symlink test"
RESTRICT="!test? ( test )"
RDEPEND="
	jpp-symlink? ( !app-misc/jp[jpp] )
	jp-symlink? ( !app-misc/jp[jp] )
	dev-python/jmespath[${PYTHON_USEDEP}]
"

python_prepare_all() {
	if ! use jpp-symlink; then
		sed -e '/"jpp = jpipe/d' -i setup.py || die
	fi
	if ! use jp-symlink; then
		sed -e '/"jp = jpipe/d' -i setup.py || die
	fi
	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" test/test_jp.py || die "jp tests failed for ${EPYTHON}"
	"${PYTHON}" test/test_jpp.py || die "jpp tests failed for ${EPYTHON}"
}
