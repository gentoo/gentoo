# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python3_{4,5} )

inherit distutils-r1

DESCRIPTION="Generate a tarball of differences between two tarballs"
HOMEPAGE="https://github.com/zmedico/tardelta"
SRC_URI="https://github.com/zmedico/tardelta/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

src_prepare() {
	sed -i "s:^\(__version__ =\).*:\\1 \"${PV}\":" src/${PN}.py || die
	distutils-r1_src_prepare
}
