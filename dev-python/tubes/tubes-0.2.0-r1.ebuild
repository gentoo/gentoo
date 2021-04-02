# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8,9} )

DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="Flow control and backpressure for event-driven applications"
HOMEPAGE="https://github.com/twisted/tubes https://pypi.org/project/Tubes/"
SRC_URI="https://github.com/twisted/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 "

DEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/twisted[${PYTHON_USEDEP}]
"

RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/remove-unnecessary-dep.patch")

distutils_enable_tests pytest
