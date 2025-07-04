# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Additional Python argparse types and actions"
HOMEPAGE="
	https://pypi.org/project/argparse-addons/
	https://github.com/eerimoq/argparse_addons/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

distutils_enable_tests pytest
