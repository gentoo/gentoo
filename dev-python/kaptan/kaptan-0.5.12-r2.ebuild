# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1 pypi

DESCRIPTION="Configuration manager in your pocket"
HOMEPAGE="https://github.com/emre/kaptan"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 x86"

RDEPEND=">=dev-python/pyyaml-3.13[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
