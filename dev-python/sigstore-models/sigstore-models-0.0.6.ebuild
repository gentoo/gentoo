# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=uv-build
PYTHON_COMPAT=( pypy3_11 python3_{11..13} )

inherit distutils-r1

DESCRIPTION="Pydantic based models for Sigstore's protobuf specifications"
HOMEPAGE="
	https://github.com/astral-sh/sigstore-models/
	https://pypi.org/project/sigstore-models/
"
SRC_URI="
	https://github.com/astral-sh/sigstore-models/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64"

RDEPEND="
	>=dev-python/pydantic-2.11.7[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.14.1[${PYTHON_USEDEP}]
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
