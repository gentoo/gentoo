# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{12..15} )

inherit distutils-r1 pypi

DESCRIPTION="Enumerate IP addresses on the local network adapters"
HOMEPAGE="
	https://github.com/ifaddr/ifaddr/
	https://pypi.org/project/ifaddr/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc ~s390 ~sparc x86"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
