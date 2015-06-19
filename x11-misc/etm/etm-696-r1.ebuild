# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/etm/etm-696-r1.ebuild,v 1.1 2014/11/07 08:03:29 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Event and Task Manager, an intuitive time management application"
HOMEPAGE="http://www.duke.edu/~dgraham/ETM/"
SRC_URI="mirror://sourceforge/etmeventandtask/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ical"

DEPEND="dev-python/wxpython:2.8[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	ical? ( dev-python/icalendar[${PYTHON_USEDEP}] )"
RDEPEND="${DEPEND}"
