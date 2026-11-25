# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=uv-build
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Python library that performs advanced searches in strings"
HOMEPAGE="
	https://github.com/Toilal/rebulk/
	https://pypi.org/project/rebulk/
"

LICENSE="MIT Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
