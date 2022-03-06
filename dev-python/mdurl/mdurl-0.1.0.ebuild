# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=flit
inherit distutils-r1

DESCRIPTION="Markdown URL utilities"
HOMEPAGE="https://pypi.org/project/mdurl/ https://github.com/hukkin/mdurl"
SRC_URI="https://github.com/hukkin/mdurl/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86"

distutils_enable_tests pytest
