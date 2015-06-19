# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gntp/gntp-1.0.1.ebuild,v 1.4 2015/04/08 08:05:18 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Python library for working with the Growl Notification Transport Protocol"
HOMEPAGE="https://github.com/kfdm/gntp http://pypi.python.org/pypi/gntp"
SRC_URI="mirror://pypi/g/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
