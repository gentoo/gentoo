# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_13t python3_14t python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Sphinx-doc extensions for sophisticated C developer"
HOMEPAGE="
	https://pypi.org/project/linuxdoc/
	https://github.com/return42/linuxdoc
"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="~amd64"
