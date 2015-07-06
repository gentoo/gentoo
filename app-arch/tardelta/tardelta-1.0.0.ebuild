# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/tardelta/tardelta-1.0.0.ebuild,v 1.1 2015/07/06 08:06:34 zmedico Exp $

EAPI=5
PYTHON_COMPAT=( python3_{3,4} )

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
