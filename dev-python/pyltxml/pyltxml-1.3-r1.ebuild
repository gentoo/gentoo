# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyltxml/pyltxml-1.3-r1.ebuild,v 1.7 2011/04/22 20:27:03 arfrever Exp $

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils

DESCRIPTION="Bindings for LTXML libraries"
HOMEPAGE="http://www.ltg.ed.ac.uk/software/xml/"
SRC_URI="ftp://ftp.cogsci.ed.ac.uk/pub/LTXML/PyLTXML-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86"
IUSE=""

DEPEND="=dev-libs/ltxml-1.2.5"
RDEPEND="${DEPEND}"

S="${WORKDIR}/PyLTXML-${PV}"

DOCS="00README"
PYTHON_MODNAME="PyLTXML"

src_prepare() {
	distutils_src_prepare

	sed \
		-e s':projects/ltg/projects/lcontrib/include:usr/include:' \
		-e s':projects/ltg/projects/lcontrib/lib:usr/lib/ltxml12:' \
		-i setup.py || die "sed failed"
}
