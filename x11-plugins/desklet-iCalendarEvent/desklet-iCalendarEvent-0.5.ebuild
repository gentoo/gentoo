# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
CONTROL_NAME="${PN#desklet-}"

inherit gdesklets

DESCRIPTION="iCalendarEvent Control for gDesklets"
HOMEPAGE="http://gdesklets.de/index.php?q=control/view/231"
LICENSE="GPL-2"
# KEYWORDS limited by dev-python/icalendar
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="${RDEPEND}
	>=dev-python/icalendar-2.0.1
	>=dev-python/python-dateutil-1.2
	dev-libs/libgamin[python]
	dev-libs/libxml2[python]"
DOCS="Manifest"
