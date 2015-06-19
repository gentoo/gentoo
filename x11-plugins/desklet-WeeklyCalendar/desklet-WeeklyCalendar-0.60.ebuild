# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/desklet-WeeklyCalendar/desklet-WeeklyCalendar-0.60.ebuild,v 1.1 2010/05/09 01:21:06 nixphoeni Exp $

inherit gdesklets

DESCRIPTION="A weekly calendar with task management capability"
HOMEPAGE="http://gdesklets.de/?q=desklet/view/111"
LICENSE="GPL-3"

SLOT="0"
IUSE=""
# KEYWORDS are limited by dev-python/icalendar
KEYWORDS="~amd64 ~x86"

RDEPEND=">=x11-plugins/desklet-iCalendarEvent-0.4"

DOCS="README"
