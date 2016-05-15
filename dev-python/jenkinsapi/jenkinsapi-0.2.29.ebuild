# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5} pypy )

inherit distutils-r1

JENKINS_VERSION="1.596.3"

DESCRIPTION="API to access resources on a Jenkins continuous-integration server"
HOMEPAGE="https://github.com/salimfadhley/jenkinsapi"
SRC_URI="https://github.com/salimfadhley/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	test? ( http://mirrors.jenkins-ci.org/war-stable/${JENKINS_VERSION}/jenkins.war -> jenkins-${JENKINS_VERSION}.war )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-python/pytz-2014.4[${PYTHON_USEDEP}]
	>=dev-python/requests-2.3.0[${PYTHON_USEDEP}]"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7 pypy)
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/unittest2[${PYTHON_USEDEP}] )"

src_unpack() {
	unpack ${P}.tar.gz

	if use test; then
		cp "${DISTDIR}/jenkins-${JENKINS_VERSION}.war" "${P}/jenkinsapi_tests/systests/jenkins.war"
	fi
}

python_test() {
	# tests fail with jenkins 1.6x
	# https://github.com/salimfadhley/jenkinsapi/issues/406
	esetup.py test
}
