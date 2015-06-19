# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/py-amqp/py-amqp-1.4.6.ebuild,v 1.4 2015/04/08 08:05:10 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

MY_PN="amqp"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Low-level AMQP client for Python (fork of amqplib)"
HOMEPAGE="https://github.com/celery/py-amqp http://pypi.python.org/pypi/amqp/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

S="${WORKDIR}/${MY_P}"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples extras test"

RDEPEND=""
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		>=dev-python/sphinxcontrib-issuetracker-0.9[${PYTHON_USEDEP}]
	)
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/nose-cover3[${PYTHON_USEDEP}]
		>=dev-python/coverage-3.0[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

# Same tests from before require a socket connection
PATCHES=( "${FILESDIR}"/${PN}-1.3.3-disable_socket_tests.patch )

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	cp -r -l funtests "${BUILD_DIR}"/lib/ || die
	cd "${BUILD_DIR}"/lib || die
	if [[ ${EPYTHON:6:1} == 3 ]]; then
		#   -n causes Python to write into hardlinked files
		2to3 --no-diffs -w funtests || die
	fi
	"${PYTHON}" funtests/run_all.py || die "Tests failed under ${EPYTHON}"
	rm -rf funtests/ || die
}

python_install_all() {
	use examples && local EXAMPLES=( demo/. )
	use doc && local HTML_DOCS=( docs/.build/html/. )
	if use extras; then
		insinto /usr/share/${PF}/extras
		doins -r extra
	fi
	distutils-r1_python_install_all
}
