# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1 optfeature

DESCRIPTION="A library for shell script-like programs in python"
HOMEPAGE="https://plumbum.readthedocs.io/en/latest/ https://github.com/tomerfiliba/plumbum"
SRC_URI="https://files.pythonhosted.org/packages/ed/ba/431d7f420cd93c4b8ccb15ed8f1c6c76c81965634fd70345af0b19c2b7bc/${P}.tar.gz"
BDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}] )"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
PATCHES=( "${FILESDIR}"/${PN}-1.7.0-test.patch )
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# Need sshd running
	rm tests/test_remote.py || die "rm test_remote.py failed"
	rm tests/test_utils.py || die "rm test_utils.py failed"
	rm tests/_test_paramiko.py || die "rm _test_paramiko.py failed"
	# Windows specific
	rm tests/test_putty.py || die "rm test_putty.py failed"
	# Needs sudo without password
	rm tests/test_sudo.py || die "rm test_sudo.py failed"
}

pkg_postinst() {
	elog "To get additional features, optional runtime dependencies may be installed:"
		optfeature "Remote commands via ssh" dev-python/paramiko
		optfeature "Progress bars in jupyter" dev-python/ipywidgets
		optfeature "Colored output in jupyter" dev-python/ipython
		optfeature "Images on the command line" dev-python/pillow
	elog ""
}
