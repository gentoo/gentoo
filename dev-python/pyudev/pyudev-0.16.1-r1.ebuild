# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Python binding to libudev"
HOMEPAGE="http://pyudev.readthedocs.org https://github.com/pyudev/pyudev"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 x86"
IUSE="pygobject pyqt4 pyside test"

RDEPEND="virtual/udev
	pygobject? ( dev-python/pygobject:2[$(python_gen_usedep 'python2*')] )
	pyqt4? ( dev-python/PyQt4[${PYTHON_USEDEP}] )
	pyside? ( dev-python/pyside[$(python_gen_usedep '!(python3_3)')] )"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/mock[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}] )"

DOCS=( CHANGES.rst README.rst )

REQUIRED_USE="pygobject? ( || ( $(python_gen_useflags 'python2*') ) )
	pyside? ( $(python_gen_useflags '!(python3_3)') )"

python_prepare_all() {
	# tests are known to pass then fail on alternate runs
	# tests: fix run_path
	sed -i -e "s|== \('/run/udev'\)|in (\1,'/dev/.udev')|g" \
		tests/test_core.py || die

	if ! use pygobject; then
		rm pyudev/glib.py || die
		sed -i -e "s|[, ]*GlibBinding()||g" \
			tests/test_observer.py || die
	fi
	if ! use pyqt4; then
		rm pyudev/pyqt4.py || die
		sed -i -e "s|Qt4Binding('PyQt4')[, ]*||g" \
			tests/test_observer.py || die
	fi
	if ! use pyside; then
		rm pyudev/pyside.py || die
		sed -i -e "s|Qt4Binding('PySide')[, ]*||g" \
			tests/test_observer.py || die
	fi
	if ! use pyqt4 && ! use pyside; then
		rm pyudev/_qt_base.py || die
	fi
	if ! use pyqt4 && ! use pyside && ! use pygobject; then
		rm tests/test_observer.py || die
	fi

	ewarn "If your PORTAGE_TMPDIR is longer in length then '/var/tmp/',"
	ewarn "change it to /var/tmp to ensure tests will pass."

	distutils-r1_python_prepare_all
}

python_test() {
	py.test || die "Tests fail with ${EPYTHON}"
}
