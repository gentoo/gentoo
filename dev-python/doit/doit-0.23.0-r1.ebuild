# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )
inherit eutils distutils-r1

DESCRIPTION="Automation tool"
HOMEPAGE="http://python-doit.sourceforge.net/ http://pypi.python.org/pypi/doit"
SRC_URI="mirror://pypi/${PN::1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE="test"

RDEPEND="dev-python/pyinotify[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]"
DEPEND="test? ( ${RDEPEND}
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}] )"
# Required for test phase
DISTUTILS_IN_SOURCE_BUILD=1
DOCS=( AUTHORS CHANGES README TODO.txt dev_requirements.txt )

python_prepare_all() {
	use test && DISTUTILS_IN_SOURCE_BUILD=1
	# Tests of this file fail due to setting of a tmp dir which can be fixed.
	# This known spurious cause does not warrant halting a testsuite
	rm -f tests/test_cmd_strace.py || die

	# These 2 tests succeed on running the suite a second time, so they are NOT broken
	# A gentoo test phase is run only once, so these unbroken tests can be safely skipped.
	sed -e s':testInit:_&:' -e s':testLoop:_&:' \
		-i tests/test_filewatch.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	# Testsuite is designed to be run by py.test, called by runtests.py
	# https://bitbucket.org/schettino72/doit/issue/78/tests-that-fail-under-pypy
	if [[ "${EPYTHON}" == pypy-c2.0 ]]; then
		sed -e 's:test_corrupted_file:_&:' \
			-e 's:test_corrupted_file_unrecognized_excep_pdep:_&:' \
			-i tests/test_dependency.py || die
	elif [[ "${EPYTHON}" == python2.6 ]]; then
		rm -f tests/test___main__.py || die
		sed -e 's:test_invalid_param_stdout:_&:' \
			-i tests/test_action.py || die
		sed -e 's:test_run_wait:_&:' \
			-i tests/test_cmd_auto.py || die
	fi
	"${PYTHON}" runtests.py
}

src_install() {
	distutils-r1_src_install

	dodoc -r doc
	docompress -x /usr/share/doc/${PF}/doc
}
