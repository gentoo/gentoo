# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1 optfeature

DESCRIPTION="Network address representation and manipulation library"
HOMEPAGE="
	https://github.com/netaddr/netaddr/
	https://pypi.org/project/netaddr/
	https://netaddr.readthedocs.io/
"
SRC_URI="
	https://github.com/netaddr/netaddr/archive/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86 ~amd64-linux ~x86-linux"

distutils_enable_sphinx docs/source
distutils_enable_tests pytest

src_prepare() {
	# Disable coverage (requires additional plugins)
	sed -i 's/^addopts = .*//' pytest.ini || die
	distutils-r1_src_prepare
}

pkg_postinst() {
	optfeature "CLI support" dev-python/ipython
}
