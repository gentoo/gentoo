# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Enumerate IP addresses on the local network adapters"
HOMEPAGE="
	https://github.com/ifaddr/ifaddr/
	https://pypi.org/project/ifaddr/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 x86 ~amd64-linux ~x86-linux"

distutils_enable_tests pytest
