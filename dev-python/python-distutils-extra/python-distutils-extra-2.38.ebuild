# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Gettext support, themed icons and scrollkeeper-based documentation in distutils"
HOMEPAGE="https://launchpad.net/python-distutils-extra"
SRC_URI="https://launchpad.net/python-distutils-extra/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

DOCS=( doc/{FAQ,README,setup.cfg.example,setup.py.example} )

DISTUTILS_IN_SOURCE_BUILD=1

python_prepare_all() {
	# Disable broken tests.
	sed \
		-e "s/test_desktop/_&/" -e "s/test_po(/_&/" \
		-e "s/test_policykit/_&/" -e "s/test_requires_provides/_&/" \
		-i test/auto.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	# 5 tests fail with disabled byte-compilation (they rely on exact
	# output from python).
	local -x PYTHONDONTWRITEBYTECODE
	"${PYTHON}" test/auto.py || die "Tests fail with ${EPYTHON}"
}
