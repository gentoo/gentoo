# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2"
PYTHON_USE_WITH="tk"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython 2.7-pypy-*"

inherit distutils

DESCRIPTION="Interactive X11 vector drawing program"
HOMEPAGE="http://www.skencil.org/"
SRC_URI="https://sk1.googlecode.com/files/${P/_alpha/alpha_rev}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="dev-python/pillow
	dev-python/pyxml
	dev-python/reportlab
	dev-lang/tk
	sys-devel/gettext"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-1.0alpha"

DOCS="README"
