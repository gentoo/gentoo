# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/Orange/Orange-2.7.2.ebuild,v 1.1 2015/07/27 08:34:12 amynka Exp $

EAPI="5"

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Open source data visualization and analysis for novice and experts."
HOMEPAGE="http://orange.biolab.si/"
SRC_URI="http://orange.biolab.si/download/files/archive/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/matplotlib[qt4]
	dev-python/pillow
	dev-python/PyQt4[webkit]
	dev-python/pyqwt
	sci-libs/scikits_learn
	sci-libs/scipy"

DEPEND="${RDEPEND}
	dev-python/numpy"
