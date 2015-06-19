# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyxenstore/pyxenstore-0.0.2.ebuild,v 1.5 2015/04/08 08:05:14 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit distutils-r1

DESCRIPTION="Provides Python interfaces for Xen's XenStore"
HOMEPAGE="https://launchpad.net/pyxenstore"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="app-emulation/xen-tools"
RDEPEND="${DEPEND}"
