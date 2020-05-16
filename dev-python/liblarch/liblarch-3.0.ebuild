# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1 virtualx

DESCRIPTION="Library to handle directed acyclic graphs"
HOMEPAGE="https://wiki.gnome.org/Projects/liblarch"
SRC_URI="https://github.com/getting-things-gnome/liblarch/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	x11-libs/gtk+:3[introspection]
"
RDEPEND="${DEPEND}"
BDEPEND="
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

python_test() {
	virtx nosetests -v || die "Tests fail with ${EPYTHON}"
}
