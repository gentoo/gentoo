# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Python function spy support for unit tests"
HOMEPAGE="
	https://github.com/beanbaginc/kgb/
	https://pypi.org/project/kgb/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

EPYTEST_PLUGINS=( "${PN}" )
EPYTEST_PLUGIN_LOAD_VIA_ENV=1
distutils_enable_tests pytest
