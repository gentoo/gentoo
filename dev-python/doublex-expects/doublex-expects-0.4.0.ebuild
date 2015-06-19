# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/doublex-expects/doublex-expects-0.4.0.ebuild,v 1.2 2014/11/28 10:25:10 pacho Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="Expects plugin for Doublex test doubles assertions"
HOMEPAGE="https://github.com/jaimegildesagredo/doublex-expects"
SRC_URI="https://github.com/jaimegildesagredo/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( >=dev-python/mamba-0.8[${PYTHON_USEDEP}] )
"
RDEPEND="
	dev-python/doublex[${PYTHON_USEDEP}]
	>=dev-python/expects-0.4.0[${PYTHON_USEDEP}]
"

python_test() {
	mamba || die "Tests failed under ${EPYTHON}"
}
