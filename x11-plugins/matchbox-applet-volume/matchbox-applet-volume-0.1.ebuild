# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/matchbox-applet-volume/matchbox-applet-volume-0.1.ebuild,v 1.13 2014/08/10 20:02:21 slyfox Exp $

EAPI=5
inherit versionator

MY_PN=${PN/matchbox/mb}
MY_P=${MY_PN}-${PV}

DESCRIPTION="Matchbox panel tray app for controlling volume levels"
HOMEPAGE="http://matchbox-project.org/"
SRC_URI="http://matchbox-project.org/sources/${MY_PN}/$(get_version_component_range 1-2)/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ppc x86"
IUSE=""

COMMON_DEPEND=">=x11-libs/libmatchbox-1.5
	x11-libs/gtk+:2"
RDEPEND="${COMMON_DEPEND}
	x11-wm/matchbox-panel"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

DOCS="AUTHORS ChangeLog NEWS README"
