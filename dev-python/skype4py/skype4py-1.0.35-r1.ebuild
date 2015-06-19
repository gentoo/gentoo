# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/skype4py/skype4py-1.0.35-r1.ebuild,v 1.1 2014/11/25 00:51:03 radhermit Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python wrapper for the Skype API"
HOMEPAGE="https://github.com/awahlig/skype4py http://pypi.python.org/pypi/Skype4Py/"
SRC_URI="https://github.com/awahlig/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="net-im/skype
	dev-python/pygobject:2[${PYTHON_USEDEP}]
	|| ( dev-python/dbus-python[${PYTHON_USEDEP}] x11-libs/libX11 )"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

DOCS=( CHANGES.rst README.rst )
