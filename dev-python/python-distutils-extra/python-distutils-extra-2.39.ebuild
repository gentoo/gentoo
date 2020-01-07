# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} pypy3 )

inherit distutils-r1

DESCRIPTION="Gettext support, themed icons and scrollkeeper-based documentation in distutils"
HOMEPAGE="https://launchpad.net/python-distutils-extra"
SRC_URI="https://launchpad.net/python-distutils-extra/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

DOCS=( doc/{README,FAQ} )

python_prepare_all() {
	# This line is run when the file is imported
	# https://bugs.launchpad.net/python-distutils-extra/+bug/1657919
	sed -i '/^unittest.main()$/d' test/auto.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	# 5 tests fail with disabled byte-compilation (they rely on exact
	# output from python).
	# The other 4 are broken.
	pytest -vv -k "not (test_pot_manual or test_pot_auto_explicit or \
		test_pot_auto or test_modules or test_packages) and not \
		(test_desktop or test_po or test_policykit or \
		test_requires_provides)" test/auto.py || \
		die "tests failed with ${EPYTHON}"
}

python_install_all() {
	distutils-r1_python_install_all

	docinto examples
	dodoc doc/{setup.cfg.example,setup.py.example}
	docompress -x /usr/share/doc/${PF}/examples
}
