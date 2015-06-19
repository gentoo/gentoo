# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/jenkinsapi/jenkinsapi-0.2.26.ebuild,v 1.1 2015/01/28 08:27:18 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="API to access resources on a Jenkins continuous-integration server"
HOMEPAGE="https://github.com/salimfadhley/jenkinsapi"
SRC_URI="https://github.com/salimfadhley/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND=">=dev-python/pytz-2014.4[${PYTHON_USEDEP}]
	>=dev-python/requests-2.3.0[${PYTHON_USEDEP}]"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		dev-util/jenkins-bin
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7 pypy)
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/unittest2[${PYTHON_USEDEP}]
	)"

# use jenkins.war from jenkins-bin instead of downloading
PATCHES=( "${FILESDIR}"/local_jenkins_war.patch )

python_test() {
	esetup.py test
}
