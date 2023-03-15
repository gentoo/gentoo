# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="A Python library to sanitize/validate a string such as filenames/file-paths/etc"
HOMEPAGE="https://github.com/thombashi/pathvalidate"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/click[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/allpairspy[${PYTHON_USEDEP}]
		dev-python/tcolorpy[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
