# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{6,7,8} )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1

DESCRIPTION="Automation Library for Denon AVR receivers"
HOMEPAGE="https://github.com/scarface-4711/denonavr"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/netifaces[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/requests-mock[${PYTHON_USEDEP}]
		dev-python/testtools[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
