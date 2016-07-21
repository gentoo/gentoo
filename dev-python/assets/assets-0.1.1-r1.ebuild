# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Cache-friendly asset management via content-hash-naming"
HOMEPAGE="https://launchpad.net/web-assets"
SRC_URI="https://launchpad.net/web-assets/trunk/${PV}/+download/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_test() {
	# The package tests assert on '/tmp', bug #450540
	local -x TMPDIR=/tmp
	nosetests || die "Tests fail with ${EPYTHON}"
}
