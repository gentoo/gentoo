# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1 cmake-utils

DESCRIPTION="IlmBase Python bindings"
HOMEPAGE="http://www.openexr.com"
SRC_URI="http://download.savannah.gnu.org/releases/openexr/${P}.tar.gz"
LICENSE="BSD"

SLOT="0/23" # based on SONAME
KEYWORDS="~x86 ~amd64"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-libs/boost-1.62.0-r1:=[python(+),${PYTHON_USEDEP}]
	>=dev-python/numpy-1.10.4
	~media-libs/ilmbase-${PV}:="

DEPEND="${RDEPEND}
	>=virtual/pkgconfig-0-r1"

RESTRICT="test"

PATCHES=( "${FILESDIR}/${P}-add-missing-files.patch" )

pkg_setup() {
	python-single-r1_pkg_setup
}
