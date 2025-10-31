# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYPI_VERIFY_REPO=https://github.com/tomerfiliba/plumbum
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 optfeature pypi

DESCRIPTION="A library for shell script-like programs in python"
HOMEPAGE="
	https://plumbum.readthedocs.io/en/latest/
	https://github.com/tomerfiliba/plumbum/
	https://pypi.org/project/plumbum/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~riscv ~x86"

BDEPEND="
	dev-python/hatch-vcs[${PYTHON_USEDEP}]
	test? (
		dev-python/psutil[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-{mock,timeout} )
distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
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

	epytest -o addopts=
}

pkg_postinst() {
	optfeature "remote commands via ssh" dev-python/paramiko
	optfeature "progress bars in jupyter" dev-python/ipywidgets
	optfeature "colored output in jupyter" dev-python/ipython
	optfeature "images on the command line" dev-python/pillow
}
