# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/pybookreader/pybookreader-0.5.0.ebuild,v 1.4 2012/02/25 12:01:14 patrick Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* 2.5 2.7-pypy-* *-jython"

inherit distutils

MY_P="PyBookReader-${PV}"

DESCRIPTION="A book reader for .fb2 .html and plain text (possibly gzipped)"
HOMEPAGE="http://pybookreader.narod.ru/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pygtk
	dev-libs/libxml2[python]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

PYTHON_MODNAME="ornamentbook pybookreader"
