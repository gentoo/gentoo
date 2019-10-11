# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python{2_7,3_{5,6,7}} )
PYTHON_REQ_USE="ssl(+)"

inherit distutils-r1

DESCRIPTION="Python FTP server library"
HOMEPAGE="https://github.com/giampaolo/pyftpdlib https://pypi.org/project/pyftpdlib/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris"
IUSE="doc examples ssl test"

RDEPEND="
	ssl? ( dev-python/pyopenssl[${PYTHON_USEDEP}] )
	dev-python/pysendfile[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
	)
	test? (
		${RDEPEND}
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

python_prepare_all() {
	sed -i "s/'sphinx.ext.intersphinx'//" docs/conf.py || die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		sphinx-build docs docs/_build/html || die
		HTML_DOCS=( docs/_build/html/. )
	fi
}

python_test() {
	# These tests fail when passing additional options to pytest
	# so we need to run them separately and not pass any args to pytest
	pytest ${PN}/test/test_misc.py || die "Tests failed with ${EPYTHON}"
	# Some of these tests tend to fail
	local skipped_tests=(
		# https://github.com/giampaolo/pyftpdlib/issues/470
		# https://bugs.gentoo.org/659108
		test_idle_data_timeout2
		# https://github.com/giampaolo/pyftpdlib/issues/471
		# https://bugs.gentoo.org/636410
		test_on_incomplete_file_received
		# https://github.com/giampaolo/pyftpdlib/issues/466
		# https://bugs.gentoo.org/659786
		test_nlst
	)
	skipped_tests=${skipped_tests[@]/%/ or}
	# Tests fail with TZ=GMT, see https://bugs.gentoo.org/666623
	TZ=UTC+1 pytest -vv \
		--ignore ${PN}/test/test_misc.py -k "not (${skipped_tests% or})" \
			|| die "Tests failed with ${EPYTHON}"
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
