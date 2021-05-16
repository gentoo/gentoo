# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit python-single-r1

DESCRIPTION="Convert your system to SYMLINK_LIB=no"
HOMEPAGE="https://github.com/mgorny/unsymlink-lib"
SRC_URI="https://github.com/mgorny/unsymlink-lib/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~ppc64"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
# tests are docker-based, you need a running docker daemon and you
# should expect leftover images
RESTRICT="test"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep '
		sys-apps/portage[${PYTHON_MULTI_USEDEP}]
	')"

src_install() {
	python_doscript unsymlink-lib
	dodoc README
}
