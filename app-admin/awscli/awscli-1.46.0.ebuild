# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 shell-completion

MY_P=aws-cli-${PV}
DESCRIPTION="Universal Command Line Environment for AWS"
HOMEPAGE="
	https://github.com/aws/aws-cli/
	https://pypi.org/project/awscli/
"
SRC_URI="
	https://github.com/aws/aws-cli/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

# technically they bundle an older version but let's keep it in sync
# with the latest, just in case
BOTOCORE_PV="$(ver_cut 1).$(( $(ver_cut 2) - 3)).$(( $(ver_cut 3) + 65 ))"
RDEPEND="
	>=dev-python/botocore-${BOTOCORE_PV}[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/rsa[${PYTHON_USEDEP}]
	>=dev-python/s3transfer-0.18.0[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	!app-admin/awscli-bin
"
BDEPEND="
	test? (
		dev-python/packaging[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( pytest-forked )
EPYTEST_XDIST=1
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# remove bundled botocore and s3transfer
	# TODO: bcdoc?
	rm -r {awscli,tests/{functional,unit}}/{botocore,s3transfer} || die
	# strip overzealous upper bounds on requirements
	sed -i -e 's:,<[=0-9.]*::' -e 's:==:>=:' setup.py || die
}

python_test() {
	local serial_tests=(
		tests/functional/ecs/test_execute_command.py::TestExecuteCommand::test_execute_command_success
		tests/functional/ssm/test_start_session.py::TestSessionManager::test_start_session_{fails,success}
		tests/functional/ssm/test_start_session.py::TestSessionManager::test_start_session_with_new_version_plugin_success
		tests/unit/customizations/codeartifact/test_adapter_login.py::TestDotNetLogin::test_login_dotnet_sources_listed_with_backtracking
		tests/unit/customizations/codeartifact/test_adapter_login.py::TestDotNetLogin::test_login_dotnet_sources_listed_with_backtracking_windows
		tests/unit/customizations/codeartifact/test_adapter_login.py::TestNuGetLogin::test_login_nuget_sources_listed_with_backtracking
		tests/unit/customizations/ecs/test_executecommand_startsession.py::TestExecuteCommand::test_execute_command_success
		tests/unit/customizations/test_sessionmanager.py
		tests/unit/test_compat.py::TestIgnoreUserSignals
		tests/unit/test_help.py
		tests/unit/test_utils.py::TestIgnoreCtrlC::test_ctrl_c_is_ignored
	)
	EPYTEST_XDIST= epytest "${serial_tests[@]}"

	local EPYTEST_DESELECT=(
		"${serial_tests[@]}"

		# flaky (some ordering?)
		tests/functional/s3/test_cp_command.py::TestCPCommand::test_multipart_upload_with_checksum_algorithm_crc32
	)
	# integration tests require AWS credentials and Internet access
	epytest tests/{functional,unit}
}

python_install_all() {
	newbashcomp bin/aws_bash_completer aws
	newzshcomp bin/aws_zsh_completer.sh _aws

	distutils-r1_python_install_all

	rm "${ED}"/usr/bin/{aws.cmd,aws_bash_completer,aws_zsh_completer.sh} || die
}
