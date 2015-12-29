# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5} pypy )

inherit distutils-r1

JENKINS_VERSION="1.596.3"

DESCRIPTION="Module for interacting with the Jenkins CI server"
HOMEPAGE="https://github.com/gvalkov/jenkins-webapi"
SRC_URI="https://github.com/gvalkov/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( http://mirrors.jenkins-ci.org/war-stable/${JENKINS_VERSION}/jenkins.war -> jenkins-${JENKINS_VERSION}.war )"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RDEPEND=">=dev-python/requests-2.7.0[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		net-analyzer/netcat
		net-misc/curl
		app-arch/unzip
		>=virtual/jre-1.7.0
		>=dev-python/pytest-2.6.3[${PYTHON_USEDEP}]
		>=dev-python/termcolor-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-1.8.0[${PYTHON_USEDEP}]
		>=dev-python/httmock-1.2.2[${PYTHON_USEDEP}] )
	doc? (
		>=dev-python/sphinx-1.2.3[${PYTHON_USEDEP}]
		>=dev-python/alabaster-0.6.1[${PYTHON_USEDEP}] )"

src_unpack() {
	unpack ${P}.tar.gz

	if use test; then
		# tests fail with jenkins 1.6x
		# https://github.com/gvalkov/jenkins-webapi/issues/14
		mkdir -p "${P}/tests/tmp/latest"
		cp "${DISTDIR}/jenkins-${JENKINS_VERSION}.war" "${P}/tests/tmp/latest/jenkins.war"
	fi
}

python_test() {
	emake test
}

python_compile_all() {
	use doc && emake -C docs html
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
