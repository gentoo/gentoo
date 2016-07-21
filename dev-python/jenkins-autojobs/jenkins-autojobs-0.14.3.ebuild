# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

MERCURIAL_PV="1.41"
GIT_PV="1.1.21"

DESCRIPTION="Scripts for automatically creating Jenkins jobs from scm branches"
HOMEPAGE="https://github.com/gvalkov/jenkins-autojobs"
SRC_URI="https://github.com/gvalkov/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
		http://updates.jenkins-ci.org/download/plugins/mercurial/${MERCURIAL_PV}/mercurial.hpi -> ${P}_mercurial_${MERCURIAL_PV}.hpi
		http://updates.jenkins-ci.org/download/plugins/git/${GIT_PV}/git.hpi -> ${P}_git_${GIT_PV}.hpi"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"

RDEPEND=">dev-python/jenkins-webapi-0.3.2[${PYTHON_USEDEP}]
	>=dev-python/lxml-3.2.3[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.11[${PYTHON_USEDEP}]
	>=dev-python/requests-2.5.0[${PYTHON_USEDEP}]"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
			dev-util/jenkins-bin
			net-analyzer/netcat
			dev-python/pytest[${PYTHON_USEDEP}] )
	doc? ( 	>=dev-python/sphinx-1.2.3[${PYTHON_USEDEP}]
			>=dev-python/alabaster-0.6.1[${PYTHON_USEDEP}] )"

PATCHES=( "${FILESDIR}/local_jenkins.patch" )

src_unpack() {
	unpack ${P}.tar.gz
	if use test; then
	  mkdir -p ${P}/tests/tmp/WEB-INF/plugins/

	  cp -v "${DISTDIR}"/${P}_mercurial_${MERCURIAL_PV}.hpi ${P}/tests/tmp/WEB-INF/plugins/mercurial.hpi
	  cp -v "${DISTDIR}"/${P}_git_${GIT_PV}.hpi ${P}/tests/tmp/WEB-INF/plugins/git.hpi
	fi
}

python_test() {
	# Test phase works with the limitation that it need be run as root in portage
	# starts jenkins
	./tests/bin/start-jenkins.sh

	py.test || die "Failed with ${EPYTHON}"

	# kills jenkins
	echo 0 | nc 127.0.0.1 60887
}

python_compile_all() {
	use doc && emake -C doc html
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/_build/html/. )
	distutils-r1_python_install_all
}
