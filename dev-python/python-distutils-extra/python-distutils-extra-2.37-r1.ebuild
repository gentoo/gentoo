# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-distutils-extra/python-distutils-extra-2.37-r1.ebuild,v 1.7 2015/04/08 08:05:09 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} pypy )

inherit distutils-r1

DESCRIPTION="Gettext support, themed icons and scrollkeeper-based documentation in distutils"
HOMEPAGE="https://launchpad.net/python-distutils-extra"
SRC_URI="http://launchpad.net/python-distutils-extra/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

DOCS=( doc/{FAQ,README,setup.cfg.example,setup.py.example} )

python_prepare_all() {
	# Disable broken tests.
	sed \
		-e "s/test_desktop/_&/" \
		-e "s/test_po(/_&/" \
		-e "s/test_policykit/_&/" \
		-e "s/test_requires_provides/_&/" \
		-i test/auto.py

	distutils-r1_python_prepare_all
}

python_test() {
	# 5 tests fail with disabled byte-compilation (they rely on exact
	# output from python).
	local -x PYTHONDONTWRITEBYTECODE

	cp -R -l test "${BUILD_DIR}"/ || die

	cd "${BUILD_DIR}" || die
	"${PYTHON}" test/auto.py || die "Tests fail with ${EPYTHON}"
}
