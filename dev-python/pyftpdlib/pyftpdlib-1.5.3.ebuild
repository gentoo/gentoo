# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_{4,5,6}} pypy{,3} )
PYTHON_REQ_USE="ssl(+)"

inherit distutils-r1

DESCRIPTION="Python FTP server library"
HOMEPAGE="https://github.com/giampaolo/pyftpdlib https://pypi.python.org/pypi/pyftpdlib"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris"
IUSE="doc examples ssl test"

RDEPEND="
	ssl? ( dev-python/pyopenssl[${PYTHON_USEDEP}] )
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

python_compile_all() {
	if use doc; then
		sphinx-build docs docs/_build/html || die
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	"${EPYTHON}" ${PN}/test/runner.py || die "Tests failed with ${EPYTHON}"
}

python_install_all() {
	if use examples; then
		docinto examples
		dodoc -r demo/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
	distutils-r1_python_install_all
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] && \
		[[ ${PYTHON_TARGETS} == *python2_7* ]] && \
		! has_version dev-python/pysendfile ; then
		elog "dev-python/pysendfile is not installed"
		elog "It can considerably speed up file transfers for Python 2"
	fi
}
