# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Compile SASS files to Qt stylesheets"
HOMEPAGE="https://github.com/spyder-ide/qtsass"
SRC_URI="https://github.com/spyder-ide/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/libsass[${PYTHON_USEDEP}]"

BDEPEND="test? (
	dev-python/flaky[${PYTHON_USEDEP}]
)"

distutils_enable_tests pytest
