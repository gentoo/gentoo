# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Python charting for 80% of humans"
HOMEPAGE="
	https://github.com/wireservice/leather/
	https://pypi.org/project/leather/
"
SRC_URI="
	https://github.com/wireservice/leather/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~arm64-macos ~x64-macos"

BDEPEND="
	test? (
		>=dev-python/cssselect-0.9.1[${PYTHON_USEDEP}]
		>=dev-python/lxml-3.6.0[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
distutils_enable_sphinx docs \
	dev-python/furo
