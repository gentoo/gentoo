# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..14} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 pypi

DESCRIPTION="Implementation of the Happy Eyeballs Algorithm (RFC 6555)"
HOMEPAGE="https://github.com/sethmlarson/rfc6555"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
