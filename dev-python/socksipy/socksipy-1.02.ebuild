# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/socksipy/socksipy-1.02.ebuild,v 1.7 2015/06/07 09:25:37 maekke Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

MY_PN="SocksiPy-branch"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="SOCKS proxy implementation for python"
HOMEPAGE="http://socksipy.sourceforge.net/ http://code.google.com/p/socksipy-branch/"
SRC_URI="http://socksipy-branch.googlecode.com/files/${MY_P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

DOCS=( BUGS README )
