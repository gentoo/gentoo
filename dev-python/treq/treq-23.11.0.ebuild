# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="A requests-like API built on top of twisted.web's Agent"
HOMEPAGE="
	https://github.com/twisted/treq/
	https://pypi.org/project/treq/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	>=dev-python/hyperlink-21.0.0[${PYTHON_USEDEP}]
	dev-python/incremental[${PYTHON_USEDEP}]
	>=dev-python/requests-2.1.0[${PYTHON_USEDEP}]
	|| (
		>=dev-python/twisted-18.7.0[ssl(-),${PYTHON_USEDEP}]
		>=dev-python/twisted-18.7.0[crypt(-),${PYTHON_USEDEP}]
	)
"
BDEPEND="
	dev-python/incremental[${PYTHON_USEDEP}]
	test? (
		dev-python/httpbin[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx docs

src_prepare() {
	# fix relative path for docs generation
	sed -e 's@("..")@("../src")@' -i docs/conf.py || die
	distutils-r1_src_prepare
}

python_test() {
	"${EPYTHON}" -m twisted.trial treq || die "Tests failed with ${EPYTHON}"
}
