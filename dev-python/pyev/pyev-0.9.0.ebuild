# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyev/pyev-0.9.0.ebuild,v 1.1 2015/06/20 15:33:32 mrueg Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Python libev interface, an event loop"
HOMEPAGE="http://code.google.com/p/pyev/
	http://pythonhosted.org/pyev/"
SRC_URI="mirror://pypi/p/pyev/${P}.tar.gz"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND="dev-libs/libev"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

HTML_DOCS=( doc/. )
