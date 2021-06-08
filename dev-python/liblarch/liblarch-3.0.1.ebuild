# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1 virtualx

DESCRIPTION="Library to handle directed acyclic graphs"
HOMEPAGE="https://wiki.gnome.org/Projects/liblarch"
SRC_URI="https://github.com/getting-things-gnome/liblarch/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	x11-libs/gtk+:3[introspection]
"
RDEPEND="${DEPEND}"

distutils_enable_tests nose

src_test() {
	virtx distutils-r1_src_test
}
