# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 optfeature

DESCRIPTION="A library for shell script-like programs in python"
HOMEPAGE="https://plumbum.readthedocs.io/en/latest/ https://github.com/tomerfiliba/plumbum"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

BDEPEND="
	test? (
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Need sshd running
	tests/test_remote.py
	tests/test_utils.py
	# Windows specific
	tests/test_putty.py
	# Needs sudo without password
	tests/test_sudo.py
	# Wrong assumptions about env handling
	tests/test_env.py::TestEnv::test_change_env
	tests/test_env.py::TestEnv::test_dictlike
	tests/test_local.py::TestLocalPath::test_iterdir
)

src_prepare() {
	sed -e '/addopts/d' -i setup.cfg || die
	distutils-r1_src_prepare
}

pkg_postinst() {
	optfeature "remote commands via ssh" dev-python/paramiko
	optfeature "progress bars in jupyter" dev-python/ipywidgets
	optfeature "colored output in jupyter" dev-python/ipython
	optfeature "images on the command line" dev-python/pillow
}
