# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Fixtures and markers to simplify testing of asynchronous tornado applications"
HOMEPAGE="https://github.com/eugeniy/pytest-tornado"
SRC_URI="https://github.com/eugeniy/pytest-tornado/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	>=dev-python/pytest-3.6[${PYTHON_USEDEP}]
	>=dev-python/tornado-5[${PYTHON_USEDEP}]
"

distutils_enable_tests --install pytest
