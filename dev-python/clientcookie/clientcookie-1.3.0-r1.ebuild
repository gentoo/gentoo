# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/clientcookie/clientcookie-1.3.0-r1.ebuild,v 1.6 2015/04/14 12:49:28 ago Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_P="ClientCookie-${PV}"

DESCRIPTION="Python module for handling HTTP cookies on the client side"
HOMEPAGE="http://wwwsearch.sourceforge.net/ClientCookie/ http://pypi.python.org/pypi/ClientCookie"
SRC_URI="http://wwwsearch.sourceforge.net/ClientCookie/src/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc x86 ~amd64-linux ~ia64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

DOCS="*.txt"
