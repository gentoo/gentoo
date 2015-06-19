# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyxenstore/pyxenstore-9999.ebuild,v 1.2 2014/08/10 21:20:28 slyfox Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 bzr

EBZR_REPO_URI="https://code.launchpad.net/~cbehrens/pyxenstore/trunk"

DESCRIPTION="Provides Python interfaces for Xen's XenStore"
HOMEPAGE="https://launchpad.net/pyxenstore"
SRC_URI=""

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="app-emulation/xen-tools"
RDEPEND="${DEPEND}"
