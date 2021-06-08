# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

DESCRIPTION="Pytest plugin that activates the fault handler module for tests"
HOMEPAGE="https://github.com/pytest-dev/pytest-faulthandler"
SRC_URI="https://github.com/pytest-dev/pytest-faulthandler/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=dev-python/pytest-5.0[${PYTHON_USEDEP}]
"
