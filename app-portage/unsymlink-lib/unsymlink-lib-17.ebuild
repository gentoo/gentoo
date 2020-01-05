# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_{6,7}} )
inherit python-single-r1

DESCRIPTION="Convert your system to SYMLINK_LIB=no"
HOMEPAGE="https://github.com/mgorny/unsymlink-lib"
SRC_URI="https://github.com/mgorny/unsymlink-lib/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	sys-apps/portage[${PYTHON_USEDEP}]"

src_test() {
	# tests are docker-based
	:
}

src_install() {
	python_doscript unsymlink-lib
	dodoc README
}
