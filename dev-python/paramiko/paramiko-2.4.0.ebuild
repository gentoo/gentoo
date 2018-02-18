# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
PYTHON_REQ_USE="threads(+)"

inherit distutils-r1

DESCRIPTION="SSH2 protocol library"
HOMEPAGE="http://www.paramiko.org/ https://github.com/paramiko/paramiko/ https://pypi.python.org/pypi/paramiko/"
# pypi tarballs are missing test data
#SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc examples test"

RDEPEND="
	>=dev-python/bcrypt-3.1.3[${PYTHON_USEDEP}]
	>=dev-python/cryptography-1.5[${PYTHON_USEDEP}]
	>=dev-python/pynacl-1.0.1[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-0.1.7[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-relaxed[${PYTHON_USEDEP}]
	)
"

python_test() {
	py.test -v || die "Tests fail with ${EPYTHON}"
}

python_compile_all() {
	use doc && esetup.py build_sphinx -s sites/docs
}

python_install_all() {
	use doc && local HTML_DOCS=( "${BUILD_DIR}"/sphinx/html/. )

	distutils-r1_python_install_all

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins demos/*
	fi
}
