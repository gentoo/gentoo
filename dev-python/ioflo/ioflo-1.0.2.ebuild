# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/ioflo/ioflo-1.0.2.ebuild,v 1.3 2015/03/08 23:50:53 pacho Exp $

EAPI=5

PYTHON_COMPAT=(python{2_7,3_4})
inherit distutils-r1

DESCRIPTION="Automated Reasoning Engine and Flow Based Programming Framework"
HOMEPAGE="https://github.com/ioflo/ioflo/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_test() {
	pushd ${PN}/app/test || die "could not find tests"
	${EPYTHON} testStart.py || die "tests failed"
	popd
}
