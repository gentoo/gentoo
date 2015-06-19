# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyavm/pyavm-0.9.1.ebuild,v 1.3 2015/04/08 08:05:29 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

MYPN=PyAVM
MYP=${MYPN}-${PV}

DESCRIPTION="Python module for Astronomy Visualization Metadata i/o"
HOMEPAGE="http://astrofrog.github.io/pyavm/"
SRC_URI="mirror://pypi/${MYPN:0:1}/${MYPN}/${MYP}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	>=dev-python/astropy-0.2[${PYTHON_USEDEP}]"

DEPEND="
	test? (
		>=dev-python/astropy-0.2[${PYTHON_USEDEP}]
		dev-python/pytest[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MYP}"

python_test() {
	py.test || die "tests for ${EPYTHON} failed"
}
