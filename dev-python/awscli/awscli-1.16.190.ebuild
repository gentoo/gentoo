# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{5,6} )

inherit bash-completion-r1 distutils-r1

DESCRIPTION="Universal Command Line Environment for AWS"
HOMEPAGE="https://pypi.org/project/awscli/"
#SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"
SRC_URI="https://github.com/aws/aws-cli/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

# requires network access
RESTRICT="test"

RDEPEND="
	>=dev-python/botocore-1.12.81[${PYTHON_USEDEP}]
	<dev-python/colorama-0.3.9.0[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	<dev-python/rsa-3.5.0.0[${PYTHON_USEDEP}]
	>=dev-python/s3transfer-0.1.12[${PYTHON_USEDEP}]
	<dev-python/pyyaml-3.13.0[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/aws-cli-${PV}"

python_test() {
	nosetests -vv || die
}

python_install_all() {
	newbashcomp bin/aws_bash_completer aws

	insinto /usr/share/zsh/site-functions
	newins bin/aws_zsh_completer.sh _aws

	distutils-r1_python_install_all

	rm "${ED%/}"/usr/bin/{aws.cmd,aws_bash_completer,aws_zsh_completer.sh} || die
}
