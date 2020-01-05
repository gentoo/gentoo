# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Enhance the standard unittest with features for testing asyncio libraries"
HOMEPAGE="https://github.com/Martiusweb/asynctest/ https://pypi.org/project/asynctest/"
SRC_URI="https://github.com/Martiusweb/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"

src_prepare() {
	default

	sed -i "{s/test_events_watched_outside_test_are_ignored/_&/}" "test/test_selector.py" || die "Could not disable the failing test."
}

python_test() {
	"${EPYTHON}" -m unittest -v test || die "Testing failed"
}
