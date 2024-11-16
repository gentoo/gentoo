# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit bash-completion-r1 distutils-r1

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
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv sparc x86"

# botocore is x.y.(z+34)
BOTOCORE_PV="$(ver_cut 1).$(ver_cut 2).$(( $(ver_cut 3-) + 34 ))"
RDEPEND="
	>=dev-python/botocore-${BOTOCORE_PV}[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/rsa[${PYTHON_USEDEP}]
	>=dev-python/s3transfer-0.10.0[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	!app-admin/awscli-bin
"
BDEPEND="
	test? (
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pytest-forked[${PYTHON_USEDEP}]
	)
"

EPYTEST_XDIST=1
distutils_enable_tests pytest

src_prepare() {
	# do not rely on bundled deps in botocore (sic!)
	find -name '*.py' -exec sed -i \
		-e 's:from botocore[.]vendored import:import:' \
		-e 's:from botocore[.]vendored[.]:from :' \
		{} + || die
	# strip overzealous upper bounds on requirements
	sed -i -e 's:,<[0-9.]*::' -e 's:==:>=:' setup.py || die
	distutils-r1_src_prepare
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
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	EPYTEST_XDIST= epytest "${serial_tests[@]}"

	local EPYTEST_DESELECT=( "${serial_tests[@]}" )
	case ${EPYTHON} in
		python3.13*)
			EPYTEST_DESELECT+=(
				# flaky (some ordering?)
				tests/functional/s3/test_cp_command.py::TestCPCommand::test_multipart_upload_with_checksum_algorithm_crc32
			)
			;;
	esac
	# integration tests require AWS credentials and Internet access
	epytest tests/{functional,unit}
}

python_install_all() {
	newbashcomp bin/aws_bash_completer aws

	insinto /usr/share/zsh/site-functions
	newins bin/aws_zsh_completer.sh _aws

	distutils-r1_python_install_all

	rm "${ED}"/usr/bin/{aws.cmd,aws_bash_completer,aws_zsh_completer.sh} || die
}
