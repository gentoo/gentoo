# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/hiredis/hiredis-0.2.0.ebuild,v 1.1 2015/07/17 13:05:46 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Python extension that wraps hiredis"
HOMEPAGE="https://github.com/pietern/hiredis-py"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

DEPEND=">=dev-libs/hiredis-0.13.1"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}"/${P}-system-libs.patch )

python_compile() {
	python_is_python3 || local -x CFLAGS="${CFLAGS} -fno-strict-aliasing"

	distutils-r1_python_compile
}
