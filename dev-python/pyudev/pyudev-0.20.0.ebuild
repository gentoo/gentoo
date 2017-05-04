# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Python binding to libudev"
HOMEPAGE="http://pyudev.readthedocs.org https://github.com/pyudev/pyudev"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 x86"
IUSE="pygobject qt4 pyside test"

RDEPEND="virtual/udev
	dev-python/six[${PYTHON_USEDEP}]
	pygobject? ( dev-python/pygobject:2[$(python_gen_usedep 'python2*')] )
	qt4? ( dev-python/PyQt4[${PYTHON_USEDEP}] )
	pyside? ( dev-python/pyside[$(python_gen_usedep '!(python3_3)')] )"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/docutils[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		>=dev-python/pytest-2.8[${PYTHON_USEDEP}]
	)"

DOCS=( CHANGES.rst README.rst )

PATCHES=(
	"${FILESDIR}/${PN}-0.19.0-skip-non-deterministic-test.patch"
)

REQUIRED_USE="pygobject? ( || ( $(python_gen_useflags 'python2*') ) )
	pyside? ( $(python_gen_useflags '!(python3_3)') )"

python_prepare_all() {
	if use test; then
		ewarn "If your PORTAGE_TMPDIR is longer in length then '/var/tmp/',"
		ewarn "change it to /var/tmp to ensure tests will pass."
	fi

	# tests are known to pass then fail on alternate runs
	# tests: fix run_path
	sed -i -e "s|== \('/run/udev'\)|in (\1,'/dev/.udev')|g" \
		tests/test_core.py || die

	# test needs needs newer dev-cpp/gccxml
	rm -f tests/test_libudev.py

	distutils-r1_python_prepare_all
}

python_test() {
	py.test || die "Tests fail with ${EPYTHON}"
}
