# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{9..12} )
inherit distutils-r1

DESCRIPTION="Evaluate an automatic speech recognition system"
HOMEPAGE="
	https://github.com/jitsi/jiwer
	https://pypi.org/project/jiwer/
"
SRC_URI="https://github.com/jitsi/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
RDEPEND="
	dev-python/rapidfuzz[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest

PATCHES=( "${FILESDIR}"/${PN}-3.0.1-tests.patch )
