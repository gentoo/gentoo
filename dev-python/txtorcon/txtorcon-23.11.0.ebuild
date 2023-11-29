# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Twisted-based Tor controller client, with state-tracking abstractions"
HOMEPAGE="
	https://txtorcon.readthedocs.org/
	https://github.com/meejah/txtorcon/
	https://pypi.org/project/txtorcon/
"
SRC_URI="
	https://github.com/meejah/txtorcon/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/automat[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/twisted[ssl,${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		sys-process/lsof
	)
"

distutils_enable_tests pytest
