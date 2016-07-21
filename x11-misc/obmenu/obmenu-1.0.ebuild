# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3
PYTHON_DEPEND="2"
inherit distutils

DESCRIPTION="Menu editor designed for openbox"
HOMEPAGE="http://obmenu.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=dev-python/pygtk-2.6"

PYTHON_MODNAME="obxml.py"

pkg_setup() {
	python_set_active_version 2
}
