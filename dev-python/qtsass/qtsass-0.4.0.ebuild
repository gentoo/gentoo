# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Compile SASS files to Qt stylesheets"
HOMEPAGE="
	https://github.com/spyder-ide/qtsass/
	https://pypi.org/project/qtsass/
"
SRC_URI="
	https://github.com/spyder-ide/qtsass/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

RDEPEND="
	>=dev-python/libsass-0.22.0[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/flaky[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
