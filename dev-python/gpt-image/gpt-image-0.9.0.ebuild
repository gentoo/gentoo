# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_13t python3_{10..13} )

inherit distutils-r1 pypi

DESCRIPTION="Tool to create GPT disk image files"
HOMEPAGE="
	https://pypi.org/project/gpt-image/
	https://github.com/swysocki/gpt-image
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests pytest
