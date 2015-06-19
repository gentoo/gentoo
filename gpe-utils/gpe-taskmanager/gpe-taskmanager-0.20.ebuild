# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gpe-utils/gpe-taskmanager/gpe-taskmanager-0.20.ebuild,v 1.1 2009/04/05 01:19:38 miknix Exp $

inherit eutils gpe

DESCRIPTION="GPE task manager"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm ~amd64 ~x86"
RDEPEND="${RDEPEND}
	gpe-base/libgpewidget
	gpe-base/libgpelaunch"
DEPEND="${DEPEND}
	${RDEPEND}"

IUSE="${IUSE}"
