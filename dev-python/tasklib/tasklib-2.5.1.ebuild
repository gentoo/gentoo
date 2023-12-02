# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="A Python library for interacting with taskwarrior databases"
HOMEPAGE="
	https://github.com/GothenburgBitFactory/tasklib
	https://pypi.org/project/tasklib/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND=">=app-misc/task-2.4.0"

distutils_enable_tests unittest
