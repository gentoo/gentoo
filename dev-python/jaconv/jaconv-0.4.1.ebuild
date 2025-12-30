# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Pure-Python Japanese character interconverter"
HOMEPAGE="
	https://pypi.org/project/jaconv/
	https://github.com/ikegami-yukino/jaconv
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
