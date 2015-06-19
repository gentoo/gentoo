# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/id3-py/id3-py-1.2.ebuild,v 1.18 2010/11/08 17:18:24 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

DESCRIPTION="Module for manipulating ID3 tags in Python"
SRC_URI="mirror://sourceforge/${PN}/${PN}_${PV}.tar.gz"
HOMEPAGE="http://id3-py.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ia64 ppc ppc64 sparc x86"
IUSE=""

DOCS="CHANGES README"
PYTHON_MODNAME="ID3.py"
