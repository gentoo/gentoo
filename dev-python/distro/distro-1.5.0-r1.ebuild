# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="Reliable machine-readable Linux distribution information for Python"
HOMEPAGE="https://distro.readthedocs.io/en/latest/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux"

distutils_enable_tests pytest
