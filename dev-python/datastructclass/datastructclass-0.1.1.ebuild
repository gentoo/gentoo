# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit-core
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="A dataclass with struct-like semantics"
HOMEPAGE="
	https://github.com/bessman/datastructclass/
	https://pypi.org/project/datastructclass/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
