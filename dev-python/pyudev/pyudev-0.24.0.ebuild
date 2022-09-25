# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )
inherit distutils-r1 optfeature

DESCRIPTION="Python binding to libudev"
HOMEPAGE="https://pyudev.readthedocs.io/en/latest/ https://github.com/pyudev/pyudev"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~ia64 ~mips ppc ppc64 ~riscv sparc x86"
IUSE="qt5"

# Known to fail on test system that aren't exactly the same devices as on CI
RESTRICT="test"

RDEPEND="virtual/udev"
BDEPEND="
	test? (
		dev-python/docutils[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)
"

DOCS=( CHANGES.rst README.rst )

distutils_enable_tests pytest

python_prepare_all() {
	if use test; then
		ewarn "If your PORTAGE_TMPDIR is longer in length then '/var/tmp/',"
		ewarn "change it to /var/tmp to ensure tests will pass."
	fi

	# tests are known to pass then fail on alternate runs
	# tests: fix run_path
	sed -e "s|== \('/run/udev'\)|in (\1,'/dev/.udev')|g" \
		-i tests/test_core.py || die

	# disable usage of hypothesis timeouts (too short)
	sed -e '/@settings/s/(/(deadline=None,/' -i tests{,/_device_tests}/*.py || die

	distutils-r1_python_prepare_all
}

pkg_postinst() {
	optfeature "PyQt5 bindings" "dev-python/PyQt5"
}
