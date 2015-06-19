# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/bitstring/bitstring-3.1.1.ebuild,v 1.9 2015/04/08 08:05:23 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )
inherit distutils-r1

DESCRIPTION="A pure Python module for creation and analysis of binary data"
HOMEPAGE="http://python-bitstring.googlecode.com/"
SRC_URI="http://python-bitstring.googlecode.com/files/${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"
DEPEND="app-arch/unzip"
RDEPEND=""

python_test() {
	if [[ ${EPYTHON} == python2.6 ]]; then
		local runner=( unit2.py )
	else
		local runner=( "${PYTHON}" -m unittest )
	fi
	pushd test > /dev/null || die
	"${runner[@]}" discover || die "Testing failed with ${EPYTHON}"
	popd test > /dev/null || die
}
