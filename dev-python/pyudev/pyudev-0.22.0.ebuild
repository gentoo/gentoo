# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Python binding to libudev"
HOMEPAGE="https://pyudev.readthedocs.io/en/latest/ https://github.com/pyudev/pyudev"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 arm ~arm64 ~mips ~x86"
IUSE="qt5"

RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	virtual/udev
	qt5? ( dev-python/PyQt5[${PYTHON_USEDEP}] )
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/docutils[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)"

DOCS=( CHANGES.rst README.rst )

#PATCHES=(
#	"${FILESDIR}/${PN}-0.19.0-skip-non-deterministic-test.patch"
#)

distutils_enable_tests pytest

python_prepare_all() {
	if use test; then
		ewarn "If your PORTAGE_TMPDIR is longer in length then '/var/tmp/',"
		ewarn "change it to /var/tmp to ensure tests will pass."
	fi

	# tests are known to pass then fail on alternate runs
	# tests: fix run_path
	sed -i -e "s|== \('/run/udev'\)|in (\1,'/dev/.udev')|g" \
		tests/test_core.py || die

	distutils-r1_python_prepare_all
}
