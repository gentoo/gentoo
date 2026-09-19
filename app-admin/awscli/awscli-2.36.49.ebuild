# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{12..14} )

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
KEYWORDS="~amd64 ~arm64 ~riscv"

RDEPEND="
	>=dev-python/colorama-0.2.5[${PYTHON_USEDEP}]
	>=dev-python/docutils-0.10[${PYTHON_USEDEP}]
	>=dev-python/ruamel-yaml-0.15.0[${PYTHON_USEDEP}]
	>=dev-python/prompt-toolkit-3.0.24[${PYTHON_USEDEP}]
	>=dev-python/distro-1.5.0[${PYTHON_USEDEP}]
	>=dev-python/awscrt-0.36.2[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.1[${PYTHON_USEDEP}]
	>=dev-python/jmespath-0.7.1[${PYTHON_USEDEP}]
	>=dev-python/urllib3-1.25.4[${PYTHON_USEDEP}]
"
# bundled dependencies
RDEPEND+="
	>=dev-python/s3transfer-0.18.0[${PYTHON_USEDEP}]
"
TODO="
	dev-python/rsa[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	!app-admin/awscli-bin
"
BDEPEND="
	dev-python/flit-core[${PYTHON_USEDEP}]
	test? (
		dev-python/jsonschema[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
EPYTEST_RERUNS=5
EPYTEST_XDIST=1
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# this package bundles botocore & s3transfer, but they are custom
	# v2 branches that were never released and are incompatible with
	# our release versions

	# strip overzealous upper bounds on requirements
	sed -i -e 's:,<[=0-9.]*::' -e 's:==:>=:' pyproject.toml || die
	# wcwidth isn't used
	sed -i -e '/wcwidth/d' pyproject.toml || die
}

python_test() {
	local -x TZ=UTC

	local EPYTEST_DESELECT=(
		# TODO
		tests/functional/autocomplete/test_main.py::test_smoke_test_completer
		tests/unit/customizations/ec2instanceconnect/test_websocket.py::TestWebsocket::test_connect_with_proxy
		tests/unit/customizations/ec2instanceconnect/test_websocket.py::TestWebsocket::test_connect_with_proxy_but_no_proxy_env_empty
		tests/unit/customizations/emr/test_emr_utils.py::TestEMRutils::test_which_with_existing_command
		tests/unit/customizations/emr/test_emr_utils.py::TestEMRutils::test_which_with_non_existing_command
		tests/unit/customizations/wizard/test_app.py
		tests/unit/test_compat.py::TestGetPreferredEncoding::test_getpreferredencoding_with_env_var
	)

	# Some tests take a lot of memory, so run parallel-safe tests first.
	local awscli_parallel_tests=(
		tests/functional/[ac-z]*/
		tests/unit/
	)
	local botocore_parallel_tests=(
		tests/functional/botocore/*/
		tests/functional/botocore/test_[cds-z]*.py
	)
	#epytest "${botocore_parallel_tests[@]}"
	epytest "${awscli_parallel_tests[@]}"

	local EPYTEST_IGNORE=(
		"${botocore_parallel_tests[@]}"
		"${awscli_parallel_tests[@]}"
	)
	EPYTEST_XDIST= epytest tests/functional
}

python_install_all() {
	newbashcomp bin/aws_bash_completer aws
	newzshcomp bin/aws_zsh_completer.sh _aws

	distutils-r1_python_install_all

	rm "${ED}"/usr/bin/{aws.cmd,aws_bash_completer,aws_zsh_completer.sh} || die
}
