# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/send2trash/send2trash-1.3.0.ebuild,v 1.3 2015/05/27 11:03:56 ago Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} pypy )

inherit distutils-r1

MY_PN="Send2Trash"

DESCRIPTION="Sends files to the Trash (or Recycle Bin)"
HOMEPAGE="http://hg.hardcoded.net/send2trash https://pypi.python.org/pypi/Send2Trash https://github.com/hsoft/send2trash"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="amd64 x86"
IUSE="doc"

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}"/${MY_PN}-${PV}
