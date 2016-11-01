# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} )
inherit distutils-r1

DESCRIPTION="Adds color to arbitrary command output"
HOMEPAGE="https://nojhan.github.com/colout/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/Babel[$(python_gen_usedep 'python2*')]
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_prepare() {
	#PyPi tarball has wrong (old, evidently) README. Upstream uses GPL-3.
	sed -e 's:BSD licensed:GPL-3 licensed:' -i README || die
	distutils-r1_src_prepare
}

pkg_postinst() {
	if [[ "${PYTHON_TARGETS}" == *python3* ]]; then
		ewarn "Though ${PN} supports Python 3, Babel does not, thus it's number parsing feature won't be used."
		ewarn "If you need it, use Python 2."
	fi
}
