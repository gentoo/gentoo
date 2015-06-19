# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/irman-python/irman-python-0.1-r1.ebuild,v 1.6 2015/04/08 08:05:27 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A minimal set of Python bindings for libirman"
HOMEPAGE="http://bluweb.com/chouser/proj/irman-python/"
SRC_URI="http://bluweb.com/chouser/proj/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/libirman"
RDEPEND="${DEPEND}"
DOCS=( README test_name.py )
