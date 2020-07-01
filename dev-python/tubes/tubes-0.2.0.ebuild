# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

DISTUTILS_USE_SETUPTOOLS="rdepend"
inherit distutils-r1

DESCRIPTION="Flow control and backpressure for event-driven applications"
HOMEPAGE="https://github.com/twisted/tubes https://pypi.org/project/Tubes/"
SRC_URI="https://github.com/twisted/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

IUSE="test"
RESTRICT="!test? ( test )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 "

DEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/twisted[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
	)
"

RDEPEND="${DEPEND}"

distutils_enable_tests pytest
