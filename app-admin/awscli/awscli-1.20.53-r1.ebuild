# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit bash-completion-r1 distutils-r1

DESCRIPTION="Universal Command Line Environment for AWS"
HOMEPAGE="https://pypi.org/project/awscli/"
#SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"
SRC_URI="https://github.com/aws/aws-cli/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/aws-cli-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

# botocore is x.(y+1).z
BOTOCORE_PV="$(ver_cut 1).$(( $(ver_cut 2) + 1)).$(ver_cut 3-)"
RDEPEND="
	<dev-python/botocore-1.23[${PYTHON_USEDEP}]
	>=dev-python/botocore-${BOTOCORE_PV}[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/rsa[${PYTHON_USEDEP}]
	>=dev-python/s3transfer-0.4.0[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
"

distutils_enable_tests --install pytest

python_test() {
	distutils_install_for_testing
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
