# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pupynere/pupynere-1.0.15-r1.ebuild,v 1.4 2015/03/09 00:03:12 pacho Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Pupynere is a PUre PYthon NEtcdf REader"
HOMEPAGE="http://pypi.python.org/pypi/pupynere/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	cd "${BUILD_DIR}" || die
	"${PYTHON}" -m doctest -v "${BUILD_DIR}"/lib/pupynere.py \
		|| die "Tests fail with ${EPYTHON}"
}
