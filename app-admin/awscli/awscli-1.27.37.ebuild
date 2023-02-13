# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit bash-completion-r1 distutils-r1 multiprocessing

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

# botocore is x.(y+2).z
BOTOCORE_PV="$(ver_cut 1).$(( $(ver_cut 2) + 2)).$(ver_cut 3-)"
RDEPEND="
	>=dev-python/botocore-${BOTOCORE_PV}[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/rsa[${PYTHON_USEDEP}]
	>=dev-python/s3transfer-0.6.0[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	!app-admin/awscli-bin
"
BDEPEND="
	test? (
		dev-python/pytest-forked[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"

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
	local EPYTEST_DESELECT=(
		# TODO
		tests/functional/eks/test_kubeconfig.py::TestKubeconfigLoader::test_load_simple
		tests/unit/customizations/eks/test_update_kubeconfig.py::TestKubeconfigSelector::test_choose_env_only
		tests/unit/customizations/eks/test_update_kubeconfig.py::TestKubeconfigSelector::test_choose_existing
		tests/unit/customizations/eks/test_kubeconfig.py::TestKubeconfigValidator::test_valid
	)

	# integration tests require AWS credentials and Internet access
	epytest tests/{functional,unit} -n "$(makeopts_jobs)" --forked
}

python_install_all() {
	newbashcomp bin/aws_bash_completer aws

	insinto /usr/share/zsh/site-functions
	newins bin/aws_zsh_completer.sh _aws

	distutils-r1_python_install_all

	rm "${ED}"/usr/bin/{aws.cmd,aws_bash_completer,aws_zsh_completer.sh} || die
}
