# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Python library to use the pseudo-tty of a docker container"
HOMEPAGE="https://github.com/d11wtq/dockerpty"
SRC_URI="https://github.com/d11wtq/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="
	test? (
		>=dev-python/docker-py-0.7.0_rc2[${PYTHON_USEDEP}]
		>=dev-python/expects-0.4[${PYTHON_USEDEP}]
	)
"
RDEPEND=">=dev-python/six-1.3.0[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
