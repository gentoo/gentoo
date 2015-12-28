# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="System tray application for Google Voice, GMail, Google Calendar, Google Reader, and Google Wave"
HOMEPAGE="http://googsystray.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=" >=dev-python/pygtk-2.14[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
