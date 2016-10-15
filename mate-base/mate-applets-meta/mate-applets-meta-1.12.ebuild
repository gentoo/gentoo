# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

if [[ ${PV} == 9999 ]]; then
	MATE_BRANCH=9999
else
	inherit versionator
	MATE_BRANCH="$(get_version_component_range 1-2)"
	KEYWORDS="amd64 ~arm x86"
fi

DESCRIPTION="Meta package for MATE panel applets"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
IUSE="appindicator gtk3 netspeed sensors"

DEPEND=""
RDEPEND="=mate-base/mate-applets-${MATE_BRANCH}*[gtk3(-)=]
	appindicator? ( =mate-extra/mate-indicator-applet-${MATE_BRANCH}*[gtk3(-)=] )
	netspeed? ( =net-analyzer/mate-netspeed-${MATE_BRANCH}*[gtk3(-)=] )
	sensors? ( =mate-extra/mate-sensors-applet-${MATE_BRANCH}*[gtk3(-)=] )
"
