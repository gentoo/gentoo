# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/watchdog/watchdog-0.8.1.ebuild,v 1.6 2014/12/05 10:18:40 ago Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Python API and shell utilities to monitor file system events"
HOMEPAGE="http://github.com/gorakhargosh/watchdog"
SRC_URI="mirror://pypi/w/watchdog/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-python/pyyaml[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	dev-python/argh[${PYTHON_USEDEP}]
	dev-python/pathtools[${PYTHON_USEDEP}]"

pkg_postinst() {
	optfeature "Bash completion" dev-python/argcomplete
}
