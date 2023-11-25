# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Remote Python Call (RPyC), a transparent and symmetric RPC library"
HOMEPAGE="https://rpyc.readthedocs.io/en/latest/
	https://pypi.org/project/rpyc/
	https://github.com/tomerfiliba-org/rpyc"
SRC_URI="https://github.com/tomerfiliba-org/rpyc/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ~riscv x86"

# USE flags gdb, numpy are used *only* to run tests depending on these packages
IUSE="test numpy gdb"
RESTRICT="!test? ( test )"

CDEPEND="numpy? ( dev-python/numpy[${PYTHON_USEDEP}] dev-python/pandas[${PYTHON_USEDEP}] )
	gdb? ( sys-devel/gdb )"

DEPEND="${CDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

RDEPEND="${CDEPEND}
	dev-python/plumbum[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}"/${PN}-5.3.0-no-gevent.patch )

src_prepare() {
	default

	# Windows specific test
	rm tests/test_win32pipes.py || die "rm tests/test_win32pipes.py failed"

	# These tests require running sshd
	rm tests/test_ssh.py tests/test_deploy.py || die "rm test_ssh.py test_deploy.py failed"

	# This test requires internet access
	rm tests/test_registry.py || die "rm test_registry.py failed"

	# This test fails with NO_CIPHERS_AVAILABLE
	rm tests/test_ssl.py || die "rm test_ssl.py failed"

	# dev-python/gevent is being removed
	rm tests/test_gevent_server.py || die "rm test_gevent_server.py failed"

	if ! use numpy
	then rm tests/test_service_pickle.py || die "rm test_service_pickle.py failed"
	fi

	if ! use gdb
	then rm tests/test_gdb.py || die "rm test_gdb.py failed"
	fi
}

python_test() {
	# for some reason, when tests are run via pytest or nose, some of them hung
	pushd tests > /dev/null || die "pushd tests failed"
	for x in test_*.py
	do PYTHONPATH="${WORKDIR}"/${P}-${EPYTHON/./_}/install/usr/lib/${EPYTHON}/site-packages ${EPYTHON} ${x} || die "${x} failed"
	done
	popd > /dev/null
}
