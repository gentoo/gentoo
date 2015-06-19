# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/cfgio/cfgio-0.1.2.ebuild,v 1.2 2014/11/28 10:04:46 pacho Exp $

EAPI=5

PYTHON_COMPAT=( python3_{3,4} )

inherit distutils-r1

DESCRIPTION="Python library for reading and writing configuration file formats found on a *nix systems"
HOMEPAGE="https://github.com/ercpe/cfgio"
SRC_URI="https://github.com/ercpe/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="test? ( dev-python/pytest[${PYTHON_USEDEP}] )"

python_test() {
	py.test || die "Testing failed with ${EPYTHON}"
}
