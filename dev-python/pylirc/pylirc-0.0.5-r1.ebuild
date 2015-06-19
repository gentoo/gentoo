# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pylirc/pylirc-0.0.5-r1.ebuild,v 1.6 2015/04/08 08:05:20 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="lirc module for Python"
HOMEPAGE="http://sourceforge.net/projects/pylirc/ http://pypi.python.org/pypi/pylirc"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="app-misc/lirc"
RDEPEND="${DEPEND}"
