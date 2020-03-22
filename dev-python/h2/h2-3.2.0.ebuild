# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="HTTP/2 State-Machine based protocol implementation"
HOMEPAGE="
	https://python-hyper.org/h2
	https://github.com/python-hyper/hyper-h2
	https://pypi.org/project/h2
"
SRC_URI="https://github.com/python-hyper/hyper-${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-python/hpack-3.0.0[${PYTHON_USEDEP}]
	<dev-python/hpack-4[${PYTHON_USEDEP}]
	>=dev-python/hyperframe-5.2.0[${PYTHON_USEDEP}]
	<dev-python/hyperframe-6[${PYTHON_USEDEP}]
"
DEPEND="
	${RDEPEND}
	test? (
		>=dev-python/hypothesis-5.5[${PYTHON_USEDEP}]
		<dev-python/hypothesis-6[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx docs/source
