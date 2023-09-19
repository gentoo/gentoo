# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )
inherit distutils-r1

DESCRIPTION="Python bindings for dev-libs/re2"
HOMEPAGE="https://github.com/facebook/pyre2/"
SRC_URI="https://github.com/facebook/pyre2/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-libs/re2:="
RDEPEND="${DEPEND}"

distutils_enable_tests setup.py
