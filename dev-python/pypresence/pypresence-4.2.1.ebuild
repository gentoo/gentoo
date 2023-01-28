# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Complete Discord IPC and Rich Presence wrapper library in Python"
HOMEPAGE="https://github.com/qwertyquerty/pypresence"
SRC_URI="https://github.com/qwertyquerty/pypresence/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_sphinx docs/sphinx dev-python/alabaster
