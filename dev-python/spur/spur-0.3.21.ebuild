# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
inherit distutils-r1

MY_P=spur.py-${PV}
DESCRIPTION="Run commands locally or over SSH using the same interface"
HOMEPAGE="https://github.com/mwilliamson/spur.py"
SRC_URI="
	https://github.com/mwilliamson/spur.py/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND="
	dev-python/paramiko[${PYTHON_USEDEP}]"

distutils_enable_tests nose

src_prepare() {
	# TODO: set up a local SSH server?
	rm tests/{ssh_tests,testing}.py || die

	# does random guesswork on top of exceptions that stopped working
	# in py3.8;  this only causes a different exception to be raised
	# https://github.com/mwilliamson/spur.py/issues/85
	sed -e 's:spawning_command_that_uses_path_env_variable_asks_if_command_is_installed:_&:' \
		-e 's:spawning_non_existent_command_raises_specific_no_such_command_exception:_&:' \
		-e 's:using_non_existent_command_and_correct_cwd_raises_no_such_command_exception:_&:' \
		-i tests/process_test_set.py || die

	distutils-r1_src_prepare
}
