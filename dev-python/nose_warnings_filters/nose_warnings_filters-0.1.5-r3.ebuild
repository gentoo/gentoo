# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

DESCRIPTION="A python module to inject warning filters during nosetest"
HOMEPAGE="https://github.com/Carreau/nose_warnings_filters"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="dev-python/nose[${PYTHON_USEDEP}]"

distutils_enable_tests nose
