# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_6 python3_7 python3_8 python3_9 )

inherit distutils-r1 virtualx

MY_P="RxPY"
DESCRIPTION="Reactive Extensions for Python"
HOMEPAGE="http://reactivex.io/"
SRC_URI="https://github.com/ReactiveX/${MY_P}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	test? (
		dev-python/pytest-asyncio[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

src_test() {
	virtx distutils-r1_src_test
}
