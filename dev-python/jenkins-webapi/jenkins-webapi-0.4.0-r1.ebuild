# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Module for interacting with the Jenkins CI server"
HOMEPAGE="https://github.com/gvalkov/jenkins-webapi"
SRC_URI="https://dev.gentoo.org/~idella4/tarballs/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="mirror"

RDEPEND=">=dev-python/requests-2.4.3[${PYTHON_USEDEP}]"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( ${RDEPEND}
		dev-util/jenkins-bin
		>=dev-python/pytest-2.6.3[${PYTHON_USEDEP}]
		>=dev-python/termcolor-1.1.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-1.8.0[${PYTHON_USEDEP}]
		>=dev-python/httmock-1.2.2[${PYTHON_USEDEP}] )
	doc? (
		>=dev-python/sphinx-1.2.3[${PYTHON_USEDEP}]
		>=dev-python/alabaster-0.6.1[${PYTHON_USEDEP}] )
	"
PATCHES=( "${FILESDIR}"/local_jenkins_war.patch )

python_test() {
	emake test
}

python_compile_all() {
	use doc && emake -C doc html
}

python_install_all() {
	use doc && local HTML_DOCS=( doc/_build/html/. )
	distutils-r1_python_install_all
}
