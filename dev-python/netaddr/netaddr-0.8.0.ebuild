# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

DESCRIPTION="Network address representation and manipulation library"
HOMEPAGE="https://github.com/drkjam/netaddr https://pypi.org/project/netaddr/ https://netaddr.readthedocs.org"
# The next release should have docs in the PyPI tarball
# https://github.com/netaddr/netaddr/commit/e6f545fccd83dbd14baff40070594cc96838c9bf
SRC_URI="https://github.com/netaddr/netaddr/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="cli"

RDEPEND="
	cli? (
		>=dev-python/ipython-0.13.1-r1[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs/source
distutils_enable_tests pytest

src_prepare() {
	# Disable coverage (requires additional plugins)
	sed -i 's/^addopts = .*//' pytest.ini || die
	distutils-r1_src_prepare
}
